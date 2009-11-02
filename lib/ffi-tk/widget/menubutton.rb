module Tk
  class MenuButton
    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('menubutton', assign_pathname, options.to_tcl_options)
    end

    # Returns the current value of the configuration option given by option.
    # Option may have any of the values accepted by the menubutton command.
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
    # Option may have any of the values accepted by the menubutton command.
    # with the button still down, and if the mouse button is then released over
    # an entry in the menu, the menubutton is unposted and the menu entry is
    # invoked. invoke it.
    # Once a menu entry has been invoked, the menubutton unposts itself.
    # case equivalent), may be typed in any window under the menubutton's
    # toplevel to post the menubutton.
    def configure(?option? ?value option value ...?)
      execute(:configure, ?option? ?value option value ...?)
    end
  end
end
