module Tk
  class Root < Toplevel
    def initialize
      @parent = nil
      @tk_pathname = '.'
    end
  end
end