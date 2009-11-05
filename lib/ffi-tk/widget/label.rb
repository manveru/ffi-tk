module Tk
  class Label
    include Cget, Configure

    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('label', assign_pathname, options.to_tcl_options)
    end
  end
end
