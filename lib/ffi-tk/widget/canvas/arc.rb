module Tk
  class Canvas
    # Items of type arc appear on the display as arc-shaped regions.
    # An arc is a section of an oval delimited by two angles (specified by the
    # :start and :extent options) and displayed in one of several ways
    # (specified by the :style option).
    class Arc < Item
      options(
        :dash, :activedash, :disableddash, :dashoffset, :fill, :activefill,
        :disabledfill, :offset, :outline, :activeoutline, :disabledoutline,
        :outlineoffset, :outlinestipple, :activeoutlinestipple,
        :disabledoutlinestipple, :stipple, :activestipple, :disabledstipple,
        :state, :tags, :width, :activewidth, :disabledwidth, :extent, :start,
        :style
      )
    end
  end
end