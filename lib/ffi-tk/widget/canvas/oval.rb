# frozen_string_literal: true
module Tk
  class Canvas
    # Items of type oval appear as circular or oval regions on the display.
    # Each oval may have an outline, a fill, or both.
    class Oval < Item
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
