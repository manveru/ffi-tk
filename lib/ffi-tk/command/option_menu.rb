# frozen_string_literal: true

# Option menu: a menubutton bound to a set of radio choices (Tk's tk_optionMenu).
module Tk
  def self.option_menu(pathname, *values)
    variable = Variable.new('the_option_menu')

    Tk.execute_only(:tk_optionMenu, pathname, variable, *values)
    variable
  end
end
