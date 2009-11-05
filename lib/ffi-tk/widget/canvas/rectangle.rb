module Tk
  class Canvas
    # Items of type rectangle appear as rectangular regions on the display.
    # Each rectangle may have an outline, a fill, or both.
    class Rectangle < Item
      options(
        :dash, :activedash, :disableddash, :dashoffset, :fill, :activefill,
        :disabledfill, :offset, :outline, :activeoutline, :disabledoutline,
        :outlineoffset, :outlinestipple, :activeoutlinestipple,
        :disabledoutlinestipple, :stipple, :activestipple, :disabledstipple,
        :state, :tags, :width, :activewidth, :disabledwidth
      )
    end
  end
end