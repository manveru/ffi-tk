# frozen_string_literal: true

# Option menu: a menubutton bound to a set of radio choices (Tk's tk_optionMenu).
module Tk
  def self.option_menu(pathname, *values)
    # Each option menu needs its own Tcl variable; derive a unique name from the
    # (unique) widget pathname so two menus never share and clobber each other.
    variable = Variable.new("option_menu#{pathname.to_s.tr('.', '_')}")

    Tk.execute_only(:tk_optionMenu, pathname, variable, *values)
    variable
  end
end
