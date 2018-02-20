# frozen_string_literal: true
module Tk
  class Canvas
    # Items of type polygon appear as polygonal or curved filled regions on the
    # display. [Polygon] supports coordinate indexing operations using the
    # [Canvas] methods: [Canvas.dchars], [Canvas.index], and [Canvas.insert].
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
