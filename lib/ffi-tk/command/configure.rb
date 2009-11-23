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
    def configure(argument = None, hints = {})
      common_configure([:configure], argument, hints)
    end

    private

    def self.common(receiver, invocation, argument, hints = {})
      result =
        if None == argument
          receiver.execute(*invocation)
        elsif argument.respond_to?(:to_tcl_options)
          receiver.execute_only(*invocation, argument.to_tcl_options)
        elsif argument.respond_to?(:to_tcl_option)
          receiver.execute(*invocation, argument.to_tcl_option)
        else
          raise ArgumentError, "Invalid argument: %p" % [argument]
        end

      if result.respond_to?(:tcl_options_to_hash)
        result.tcl_options_to_hash(hints)
      else
        result
      end
    end

    def common_configure(invocation, argument, hints = {})
      Configure.common(self, invocation, argument, hints)
    end

    def register_command(name, &block)
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
        arg = '%d %i %P %s %S %v %V %W'
      else
        arg = ''
      end

      @commands ||= {}

      unregister_command(name)
      id, command = Tk.register_proc(block, arg)
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
