module Tk
  class Entry < Widget
    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('entry', assign_pathname, options)
    end

    def insert(index, string)
      execute(:insert, index, string)
    end
  end
end