module Tk
  class Widget
    include Pack, Destroy, Bind

    attr_reader :parent, :tk_pathname

    def to_tcl
      tk_pathname.dump
    end

    private

    def assign_pathname
      @tk_pathname = Tk.register_object(parent, self)
    end

    def execute(command, *args)
      Tk.execute(tk_pathname, command, *args)
    end
  end
end