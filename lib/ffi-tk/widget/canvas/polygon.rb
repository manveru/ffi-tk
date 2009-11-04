module Tk
  class Canvas
    class Polygon < Item
      options(
        :dash, :activedash, :disableddash, :dashoffset, :fill, :activefill,
        :disabledfill, :offset, :outline, :activeoutline, :disabledoutline,
        :outlinestipple, :activeoutlinestipple, :disabledoutlinestipple,
        :stipple, :activestipple, :disabledstipple, :state, :tags, :width,
        :activewidth, :disabledwidth, :joinstyle, :smooth, :splinesteps
      )
    end
  end
end