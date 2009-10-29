module Tk
  class Root < Widget
    def initialize
      @parent = nil
      @tk_pathname = '.'
    end
  end
end