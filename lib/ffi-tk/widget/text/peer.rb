module Tk
  class Text
    class Peer < Text
      def initialize(parent, options = {})
        @parent = parent
        Tk.execute(parent.tk_pathname, 'peer', 'create', assign_pathname, options)
      end
    end
  end
end