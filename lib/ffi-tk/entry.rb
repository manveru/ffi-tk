module Tk
  class Entry < Widget
    include Cget

    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('entry', assign_pathname, options)
    end

    def bbox(index)
      execute(:bbox, index).to_a.map(&:to_i)
    end

    def insert(index, string)
      execute(:insert, index, string)
    end

    def get
      execute(:get).to_s
    end
  end
end