module Tk
  class MenuButton
    include Cget, Configure

    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('menubutton', assign_pathname, options.to_tcl_options)
    end
  end
end
