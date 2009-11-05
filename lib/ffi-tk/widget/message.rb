module Tk
  class Message
    include Cget, Configure

    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('message', assign_pathname, options.to_tcl_options)
    end
  end
end
