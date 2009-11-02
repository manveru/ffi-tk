module Tk
  class Message
    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('message', assign_pathname, options.to_tcl_options)
    end

    # Returns the current value of the configuration option given by option.
    # Option may have any of the values accepted by the message command.
    def cget(option)
      execute(:cget, option)
    end

    # Query or modify the configuration options of the widget.
    # If no option is specified, returns a list describing all of the available
    # options for pathName (see Tk_ConfigureInfo for information on the format
    # of this list).
    # If option is specified with no value, then the command returns a list
    # describing the one named option (this list will be identical to the
    # corresponding sublist of the value returned if no option is specified).
    # If one or more option-value pairs are specified, then the command
    # modifies the given widget option(s) to have the given value(s); in this
    # case the command returns an empty string.
    # Option may have any of the values accepted by the message command.
    def configure(?option? ?value option value ...?)
      execute(:configure, ?option? ?value option value ...?)
    end
  end
end
