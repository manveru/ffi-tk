# frozen_string_literal: true

module Tk
  TkGeometry = Struct.new(:original, :width, :height, :x, :y) do
    def initialize(tcl_string)
      str = tcl_string.to_s
      self.original = str

      if /^=?(?<width>\d+)x(?<height>\d+)(?<x>[+-]\d+)(?<y>[+-]\d+)$/ =~ str
        self.width = Integer(width)
        self.height = Integer(height)
        self.x = Integer(x)
        self.y = Integer(y)
      elsif /^=?(?<width>\d+)x(?<height>\d+)$/ =~ str
        self.width = Integer(width)
        self.height = Integer(height)
      elsif /^=?(?<x>[+-]\d+)(?<y>[+-]\d+)$/ =~ str
        self.x = Integer(x)
        self.y = Integer(y)
      else
        raise format('Invalid geometry: %p', tcl_string)
      end
    end

    def to_tcl
      if width && height && x && y
        format('=%dx%d%+d%+d', width, height, x, y)
      elsif width && height
        format('=%dx%d', width, height)
      elsif x && y
        format('=%+d%+d', x, y)
      else
        raise format('Incomplete geometry: %p', self)
      end
    end
  end
end
