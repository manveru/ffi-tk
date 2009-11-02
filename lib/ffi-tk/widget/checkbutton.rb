module Tk
  class CheckButton
    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('checkbutton', assign_pathname, options.to_tcl_options)
    end

    # Returns the current value of the configuration option given by option.
    # Option may have any of the values accepted by the checkbutton command.
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
    # Option may have any of the values accepted by the checkbutton command.
    def configure(?option? ?value option value ...?)
      execute(:configure, ?option? ?value option value ...?)
    end

    # Deselects the checkbutton and sets the associated variable to its “off”
    # value.
    def deselect
      execute(:deselect)
    end

    # Flashes the checkbutton.
    # This is accomplished by redisplaying the checkbutton several times,
    # alternating between active and normal colors.
    # At the end of the flash the checkbutton is left in the same normal/active
    # state as when the command was invoked.
    # This command is ignored if the checkbutton's state is disabled.
    def flash
      execute(:flash)
    end

    # Does just what would have happened if the user invoked the checkbutton
    # with the mouse: toggle the selection state of the button and invoke the
    # Tcl command associated with the checkbutton, if there is one.
    # The return value is the return value from the Tcl command, or an empty
    # string if there is no command associated with the checkbutton.
    # This command is ignored if the checkbut‐ ton's state is disabled.
    def invoke
      execute(:invoke)
    end

    # Selects the checkbutton and sets the associated variable to its “on”
    # value.
    def select
      execute(:select)
    end

    # Toggles the selection state of the button, redisplaying it and modifying
    # its associated variable to reflect the new state.
    # pressed over a checkbutton, the button activates whenever the mouse
    # pointer is inside the button, and deactivates whenever the mouse pointer
    # leaves the button.
    # minus (-) deselects the button.
    # labelframe .lbl -text "Steps:" checkbutton .c1 -text Lights -variable
    # lights checkbutton .c2 -text Cameras -variable cameras checkbutton .c3
    # -text Action! -variable action pack .c1 .c2 .c3 -in .lbl pack .lbl
    def toggle
      execute(:toggle)
    end
  end
end
