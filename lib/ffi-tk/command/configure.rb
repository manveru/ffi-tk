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
        execute_only('configure', arguments.first.to_hash)
      elsif arguments.size == 1
        argument = tcl_option(arguments.first)
        execute('configure', argument)
      else
        raise ArgumentError, "Invalid arguments: %p" % [arguments]
      end
    end
  end
end