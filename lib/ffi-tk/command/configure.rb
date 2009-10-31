module Tk
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
    def configure(*arguments)
      if arguments.empty?
        execute('configure')
      elsif arguments.size == 1 && arguments.first.respond_to?(:to_hash)
        execute_only('configure', option_hash_to_tcl(arguments.first.to_hash))
      elsif arguments.size == 1
        argument = tcl_option(arguments.first)
        execute('configure', argument)
      else
        raise ArgumentError, "Invalid arguments: %p" % [arguments]
      end
    end

    private

    def register_command(name, &block)
      case name
      when :validatecommand
        arg = '%d %i %P %s %S %v %V %W'
        wrap = lambda{|action, index, current, previous, diff, type_set, trigger, name|
          # p action: action
          # p index: index
          # p current: current
          # p previous: previous
          # p diff: diff
          # p type_set: type_set
          # p trigger: trigger
          # p name: name
          block.call(action, index, current, previous, diff, type_set, trigger, name)
        }
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
      else
        wrap = block
      end

      @commands ||= {}

      unregister_command(name)
      id, command = Tk.register_proc(wrap, arg.to_s)
      @commands[name] = id

      return command
    end

    def unregister_command(name, id = @commands[name])
      return unless id
      @commands.delete(id)
      Tk.unregister_proc(id)
    end

    def unregister_commands
      return unless @commands
      @commands.each{|name, id| unregister_command(name, id) }
    end
  end
end