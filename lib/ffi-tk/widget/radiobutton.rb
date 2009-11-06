module Tk
  class RadioButton < Button
    include Cget, Configure

    # Deselects the radiobutton and sets the associated variable to an empty
    # string. If this radiobutton was not currently selected, the command has
    # no effect.
    def deselect
      execute_only(:deselect)
    end

    # Flashes the radiobutton.
    # This is accomplished by redisplaying the radiobutton several times,
    # alternating between active and normal colors.
    # At the end of the flash the radiobutton is left in the same normal/active
    # state as when the command was invoked.
    # This command is ignored if the radiobutton's state is disabled.
    def flash
      execute_only(:flash)
    end

    # Does just what would have happened if the user invoked the radiobutton
    # with the mouse: selects the button and invokes its associated Tcl
    # command, if there is one.
    # The return value is the return value from the Tcl command, or an empty
    # string if there is no command associated with the radiobutton.
    # This command is ignored if the radiobutton's state is disabled.
    def invoke
      execute_only(:invoke)
    end

    # Selects the radiobutton and sets the associated variable to the value
    # corresponding to this widget.
    # pressed over a radiobutton, the button activates whenever the mouse
    # pointer is inside the button, and deactivates whenever the mouse pointer
    # leaves the button.
    def select
      execute_only(:select)
    end
  end
end
