module Tk
  class Text
    class Peer < Text
      def initialize(tk_parent, options = {})
        @tk_parent = tk_parent
        Tk.execute(tk_parent.tk_pathname, 'peer', 'create', assign_pathname, options)
      end
    end
  end
end
