module Tk
  class Button < Widget
    # TODO: implement custom procs
    def initialize(parent, options = {}, &block)
      @parent = parent
      # options[:command] = Tk.proc_to_tcl(block) if block
      Tk.execute('button', assign_pathname, options)
    end
  end
end