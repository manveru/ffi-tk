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
    def configure(argument = None)
      # The widget-level configure is itself a describe-tuple surface, coerced
      # by the receiver's declared Option schema.
      Configure.describe(self, [:configure], self.class.option_schema, argument)
    end

    # Build the Tcl option hash for a menu entry-creation subcommand (menu
    # add/insert), registering a Ruby block as a Tcl command for any option the
    # +schema+ types :command (consulting the menu-entry Option schema).
    def option_hash_to_tcl(hash, schema)
      hash.to_h do |key, value|
        value = register_command(key, &value) if schema.type_for(key) == :command
        [key.to_tcl_option, value]
      end
    end

    # Parse Tk's describe-tuple output into OptionDescription(s), coercing the
    # value and default fields by the schema's declared Option type. Reads raw
    # Tcl strings (never EvalResult.guess), faithful to Tk's `configure`:
    #   no option  -> Hash{name => OptionDescription} for every option,
    #                 INCLUDING synonym (alias) entries;
    #   one option -> that option's single OptionDescription.
    def self.read_descriptions(receiver, invocation, schema, option = None)
      if None.equal?(option)
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
    #   bulk (None.equal?(option)) -> Hash{name => coerced value}, INCLUDING
    #                            empty-valued options (empty-value rule);
    #   one option            -> that option's coerced bare value.
    # The caller places the queried option token into +invocation+ itself, so a
    # surface whose grammar is not plain "... -option" (font actual's `-- char`)
    # stays faithful; +option+ only names the type to coerce the single value.
    def self.read_flat(receiver, invocation, schema, option = None)
      raw = receiver.execute_string(*invocation)
      return Option::Coercer.coerce(schema.type_for(option), raw) unless None.equal?(option)

      Option::Coercer.split_list(raw).each_slice(2).with_object({}) do |(name, value), flat|
        key = Option::Schema.normalize(name)
        flat[key] = Option::Coercer.coerce(schema.type_for(key), value)
      end
    end

    # Dispatch a describe-tuple "-opt val" subcommand surface (listbox item,
    # menu entry, panedwindow pane, place): no argument reads every option's
    # OptionDescription, a Symbol/String reads one option's OptionDescription,
    # an option Hash sets them. Reads route through read_descriptions
    # (type-directed coercion of value/default); sets stay a plain execute_only.
    def self.describe(receiver, invocation, schema, argument)
      if None.equal?(argument)
        read_descriptions(receiver, invocation, schema)
      elsif argument.respond_to?(:to_tcl_options)
        receiver.execute_only(*invocation, argument.to_tcl_options)
      elsif argument.respond_to?(:to_tcl_option)
        read_descriptions(receiver, invocation, schema, argument)
      else
        raise ArgumentError, format('Invalid argument: %p', argument)
      end
    end

    # Dispatch a flat "-opt val" subcommand surface: no argument reads the whole
    # surface, a Symbol/String reads one option's bare value, an option Hash sets
    # them. Reads route through read_flat (type-directed coercion by the surface's
    # Option schema); sets stay a plain execute_only.
    def self.flat(receiver, invocation, schema, argument)
      if None.equal?(argument)
        read_flat(receiver, invocation, schema)
      elsif argument.respond_to?(:to_tcl_options)
        receiver.execute_only(*invocation, argument.to_tcl_options)
      elsif argument.respond_to?(:to_tcl_option)
        read_flat(receiver, invocation + [argument.to_tcl_option], schema, argument)
      else
        raise ArgumentError, format('Invalid argument: %p', argument)
      end
    end

    private

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
