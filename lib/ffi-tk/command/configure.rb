# frozen_string_literal: true

module Tk
  # Query and set widget configuration options.
  # Backs the shared `configure` command.
  module Configure
    # Query or modify the configuration options of the widget.
    # If no option is specified, returns a list describing all of the available
    # options for pathName (see Tk_ConfigureInfo for information on the format
    # of this list).
    # If option is specified with no value, then the command returns a list
    # describing the one named option (this list will be identical to the
    # corresponding sublist of the value returned if no option is specified).
    # If one or more option-value pairs are specified, then the command modifies
    # the given widget option(s) to have the given value(s); in this case the
    # command returns an empty string.
    # Option may have any of the values accepted by the text command.
    #
    # @example Usage
    #   text.configure(width: 100, height: 200)
    #   text.configure(:width)
    #   text.configure
    def configure(argument = None, hints = {})
      schema = self.class.option_schema
      return common_configure([:configure], argument, hints) unless schema

      if argument == None
        Configure.read_descriptions(self, [:configure], schema)
      elsif argument.respond_to?(:to_tcl_options)
        execute_only(:configure, argument.to_tcl_options)
      elsif argument.respond_to?(:to_tcl_option)
        Configure.read_descriptions(self, [:configure], schema, argument)
      else
        raise ArgumentError, format('Invalid argument: %p', argument)
      end
    end

    # Parse Tk's describe-tuple output into OptionDescription(s), coercing the
    # value and default fields by the schema's declared Option type. Reads raw
    # Tcl strings (never EvalResult.guess), faithful to Tk's `configure`:
    #   no option  -> Hash{name => OptionDescription} for every option,
    #                 INCLUDING synonym (alias) entries;
    #   one option -> that option's single OptionDescription.
    def self.read_descriptions(receiver, invocation, schema, option = None)
      if option == None
        rows = Option::Coercer.split_list(receiver.execute_string(*invocation))
        rows.each_with_object({}) do |row, descriptions|
          description = describe_row(Option::Coercer.split_list(row), schema)
          descriptions[description.name] = description
        end
      else
        fields = Option::Coercer.split_list(receiver.execute_string(*invocation, option.to_tcl_option))
        describe_row(fields, schema)
      end
    end

    # Turn one describe-tuple, already split into its raw string fields, into an
    # OptionDescription. Tk reports an alias as the 2-field synonym form
    # {-alias -canonical}; every other option as the 5-field normal form
    # {-name dbName dbClass default current}.
    def self.describe_row(fields, schema)
      name = Option::Schema.normalize(fields.first)
      return OptionDescription.new(name, nil, nil, nil, nil, Option::Schema.normalize(fields.last)) if fields.size == 2

      _option, db_name, db_class, default, value = fields
      type = schema.type_for(name)
      OptionDescription.new(name, db_name, db_class,
                            Option::Coercer.coerce(type, default),
                            Option::Coercer.coerce(type, value), nil)
    end

    # Read a Tk "-option value ..." flat surface (font actual/configure, wm
    # attributes, tk caret, treeview column/heading/item/tag, notebook tab,
    # panedwindow pane) and coerce every value by the surface's declared Option
    # type. Reads the raw Tcl string (never EvalResult.guess), so it is immune
    # to shimmering:
    #   bulk (option == None) -> Hash{name => coerced value}, INCLUDING
    #                            empty-valued options (empty-value rule);
    #   one option            -> that option's coerced bare value.
    # The caller places the queried option token into +invocation+ itself, so a
    # surface whose grammar is not plain "... -option" (font actual's `-- char`)
    # stays faithful; +option+ only names the type to coerce the single value.
    def self.read_flat(receiver, invocation, schema, option = None)
      raw = receiver.execute_string(*invocation)
      return Option::Coercer.coerce(schema.type_for(option), raw) unless option == None

      Option::Coercer.split_list(raw).each_slice(2).each_with_object({}) do |(name, value), flat|
        key = Option::Schema.normalize(name)
        flat[key] = Option::Coercer.coerce(schema.type_for(key), value)
      end
    end

    # Dispatch a flat "-opt val" subcommand surface: no argument reads the whole
    # surface, a Symbol/String reads one option's bare value, an option Hash sets
    # them. Reads route through read_flat (type-directed coercion); sets stay a
    # plain execute_only. The value-add over Configure.common is the schema path.
    def self.flat(receiver, invocation, schema, argument)
      if argument == None
        read_flat(receiver, invocation, schema)
      elsif argument.respond_to?(:to_tcl_options)
        receiver.execute_only(*invocation, argument.to_tcl_options)
      elsif argument.respond_to?(:to_tcl_option)
        read_flat(receiver, invocation + [argument.to_tcl_option], schema, argument)
      else
        raise ArgumentError, format('Invalid argument: %p', argument)
      end
    end

    def self.common(receiver, invocation, argument, hints = {})
      if argument == None
        receiver.execute(*invocation).tcl_options_to_hash(hints)
      elsif argument.respond_to?(:to_tcl_options)
        receiver.execute_only(*invocation, argument.to_tcl_options)
      elsif argument.respond_to?(:to_tcl_option)
        # Single-option query returns the current value. Classic Tk commands
        # answer with the [option, dbname, dbclass, default, current]
        # describe-tuple — list-typed for most commands, string-typed for
        # canvas itemconfigure (recognizable by its leading option name), so
        # extract the last element. ttk commands answer with the bare value.
        option = argument.to_tcl_option
        result = receiver.execute(*invocation, option)
        if result.is_a?(Array) && result.size == 5 && result.first == option
          result.last
        elsif result.is_a?(String) && result.start_with?("#{option} ")
          Tk.execute(:lindex, result, :end)
        else
          result
        end
      else
        raise ArgumentError, format('Invalid argument: %p', argument)
      end
    end

    private

    def common_configure(invocation, argument, hints = {})
      Configure.common(self, invocation, argument, hints)
    end

    def register_command(name, &block)
      arg =
        case name
        when :validatecommand
          # %d Type of action: 1 for insert, 0 for delete, or -1 for focus, forced
          #    or textvariable validation.
          # %i Index of char string to be inserted/deleted, if any, otherwise -1.
          # %P The value of the entry if the edit is allowed.
          #    If you are configuring the entry widget to have a new textvariable,
          #    this will be the value of that textvariable.
          # %s The current value of entry prior to editing.
          # %S The text string being inserted/deleted, if any, {} otherwise.
          # %v The type of validation currently set.
          # %V The type of validation that triggered the callback (key, focusin,
          #    focusout, forced).
          # %W The name of the entry widget.
          '%d %i %P %s %S %v %V %W'
        else
          ''
        end

      @commands ||= {}

      unregister_command(name)
      id, command = Tk.register_proc(block, arg)
      @commands[name] = id

      command
    end

    def unregister_command(name, id = @commands[name])
      return unless id

      @commands.delete(id)
      Tk.unregister_proc(id)
    end

    def unregister_commands
      return unless @commands

      @commands.each { |name, id| unregister_command(name, id) }
    end
  end
end
