module Tk
  class RadioButton
    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('radiobutton', assign_pathname, options.to_tcl_options)
    end

    # Returns the current value of the configuration option given by option.
    # Option may have any of the values accepted by the radiobutton command.
    def cget(option)
      execute(:cget, option)
    end

    # Query or modify the configuration options of the widget.
    # If no option is specified, returns a list describing all of the available
    # options for pathName (see Tk_ConfigureInfo for information on the format
    # of this list).
    # If option is specified with no value, the command returns a list
    # describing the one named option (this list will be identical to the
    # corresponding sublist of the value returned if no option is specified).
    # If one or more option-value pairs are specified, the command modifies the
    # given widget option(s) to have the given value(s); in this case the com‐
    # mand returns an empty string.
    # Option may have any of the values accepted by the radiobutton command.
    def configure(?option? ?value option value ...?)
      execute(:configure, ?option? ?value option value ...?)
    end

    # Deselects the radiobutton and sets the associated variable to an empty
    # string. If this radiobutton was not currently selected, the command has
    # no effect.
    def deselect
      execute(:deselect)
    end

    # Flashes the radiobutton.
    # This is accomplished by redisplaying the radiobutton several times,
    # alternating between active and normal colors.
    # At the end of the flash the radiobutton is left in the same normal/active
    # state as when the command was invoked.
    # This command is ignored if the radiobutton's state is disabled.
    def flash
      execute(:flash)
    end

    # Does just what would have happened if the user invoked the radiobutton
    # with the mouse: selects the button and invokes its associated Tcl
    # command, if there is one.
    # The return value is the return value from the Tcl command, or an empty
    # string if there is no command associated with the radiobutton.
    # This command is ignored if the radiobutton's state is disabled.
    def invoke
      execute(:invoke)
    end

    # Selects the radiobutton and sets the associated variable to the value
    # corresponding to this widget.
    # pressed over a radiobutton, the button activates whenever the mouse
    # pointer is inside the button, and deactivates whenever the mouse pointer
    # leaves the button.
    def select
      execute(:select)
    end
  end
end
