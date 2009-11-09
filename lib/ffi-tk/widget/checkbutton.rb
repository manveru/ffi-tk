module Tk
  # Create and manipulate checkbutton widgets
  class CheckButton < Button
    include Cget, Configure

    def self.tk_command; 'checkbutton'; end

    def initialize(parent = Tk.root, options = None)
      if block_given?
        super do |options|
          options[:command] = register_command(:command, &Proc.new)
        end
      else
        super
      end
    end

    # Deselects the checkbutton and sets the associated variable to its “off”
    # value.
    def deselect
      execute_only(:deselect)
    end

    # Flashes the checkbutton.
    # This is accomplished by redisplaying the checkbutton several times,
    # alternating between active and normal colors.
    # At the end of the flash the checkbutton is left in the same normal/active
    # state as when the command was invoked.
    # This command is ignored if the checkbutton's state is disabled.
    def flash
      execute_only(:flash)
    end

    # Does just what would have happened if the user invoked the checkbutton
    # with the mouse: toggle the selection state of the button and invoke the
    # Tcl command associated with the checkbutton, if there is one.
    # The return value is the return value from the Tcl command, or an empty
    # string if there is no command associated with the checkbutton.
    # This command is ignored if the checkbut‐ ton's state is disabled.
    def invoke
      execute_only(:invoke)
    end

    # Selects the checkbutton and sets the associated variable to its “on”
    # value.
    def select
      execute_only(:select)
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
      execute_only(:toggle)
    end
  end
end
