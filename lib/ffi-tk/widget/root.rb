# frozen_string_literal: true
module Tk
  class Root < Toplevel
    def initialize
      @tk_parent = nil
      @tk_pathname = '.'
    end
  end
end
