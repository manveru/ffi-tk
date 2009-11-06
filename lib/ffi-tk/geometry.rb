module Tk
  class TkGeometry < Struct.new(:original, :width, :height, :x, :y)
    def initialize(tcl_string)
      case tcl_string.to_s
      when /^\=?(?<width>\d+)x(?<height>\d+)(?<x>[+-]\d+)(?<y>[+-]\d+)$/
        md = $~
        self.width, self.height, self.x, self.y =
          md[:width].to_i, md[:height].to_i, md[:x].to_i, md[:y].to_i
      when /^\=?(?<width>\d+)x(?<height>\d+)$/
        md = $~
        self.width, self.height = md[:width].to_i, md[:height].to_i
      when /^\=?(?<x>[+-]\d+)(?<y>[+-]\d+)$/
        md = $~
        self.x, self.y = md[:x].to_i, md[:y].to_i
      else
        raise "Invalid geometry: %p" % [tcl_string]
      end
    end

    def to_tcl
      if width && height && x && y
        "=%dx%d%+d%+d" % [width, height, x, y]
      elsif width && height
        "=%dx%d%" % [width, height]
      elsif x && y
        "=+d%+d" % [x, y]
      else
        raise "Incomplete geometry: %p" % [self]
      end
    end
  end
end