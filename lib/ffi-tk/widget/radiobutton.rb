# frozen_string_literal: true

module Tk
  # A button representing one of a set of mutually exclusive choices.
  # Wraps Tk's `radiobutton` command.
  class RadioButton < Button
    include Configure
    include Cget

    # Option schema (radiobutton(3tk) WIDGET-SPECIFIC + options(3tk) STANDARD).
    # RadioButton overrides tk_command, so it inherits nothing from Button and
    # declares its full schema. -value/-tristatevalue store arbitrary values in
    # the linked variable (:string); -select/-tristateimage name Tk images
    # (:string); -variable links a Tcl variable.
    classic_options
    widget_options(
      command: :command,
      height: :integer,
      indicatoron: :boolean,
      offrelief: :symbol,
      overrelief: :symbol,
      selectcolor: :color,
      selectimage: :string,
      state: :symbol,
      tristateimage: :string,
      tristatevalue: :string,
      value: :string,
      variable: :variable,
      width: :integer
    )

    def self.tk_command
      'radiobutton'
    end

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
    # The return value is the return value from the Tcl command, or nil if
    # there is no command associated with the radiobutton.
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
      execute_only(:select)
    end
  end
end
