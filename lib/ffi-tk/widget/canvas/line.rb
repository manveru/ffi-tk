module Tk
  class Canvas
    # Items of type line appear on the display as one or more connected line
    # segments or curves.
    # Line items support coordinate indexing operations using the Canvas
    # methods: [Canvas.dchars], [Canvas.index], and [Canvas.insert].
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