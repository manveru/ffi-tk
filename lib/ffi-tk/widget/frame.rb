module Tk
  class Frame < Widget
    include Cget, Configure

    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('frame', assign_pathname, options.to_tcl_options)
    end
  end
end