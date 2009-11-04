module Tk
  class Canvas
    class Line < Item
      options(
        :dash, :activedash, :disableddash, :dashoffset, :fill, :activefill,
        :disabledfill, :stipple, :activestipple, :disabledstipple, :state,
        :tags, :width, :activewidth, :disabledwidth, :arrow, :arrowshape,
        :capstyle, :joinstyle, :smooth, :splinesteps
      )
    end
  end
end