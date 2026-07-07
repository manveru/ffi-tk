# frozen_string_literal: true

module Tk
  class Canvas
    # Items of type line appear on the display as one or more connected line
    # segments or curves.
    # Line items support coordinate indexing operations using the Canvas
    # methods: [Canvas.dchars], [Canvas.index], and [Canvas.insert].
    class Line < Item
      # Types from canvas(3tk) LINE ITEMS. -arrow/-capstyle/-joinstyle are
      # keyword sets (:symbol); -arrowshape is a 3-element screen-distance list
      # (:list); -smooth is quad-state (a boolean OR a smoothing-method name --
      # bezier normalises to "true", but raw and custom methods read back as
      # their own name), so it is :string, not :boolean: a :boolean would flatten
      # the enabled "raw" method to false, inverting the truth. -splinesteps a
      # positive :integer; -offset (which Tk reports here though the man page
      # omits it) and the width/dash specs stay lossless :string.
      item_options(
        dash: :string, activedash: :string, disableddash: :string,
        dashoffset: :string, fill: :color, activefill: :color,
        disabledfill: :color, offset: :string, stipple: :bitmap,
        activestipple: :bitmap, disabledstipple: :bitmap, state: :symbol,
        tags: :list, width: :string, activewidth: :string,
        disabledwidth: :string, arrow: :symbol, arrowshape: :list,
        capstyle: :symbol, joinstyle: :symbol, smooth: :string,
        splinesteps: :integer
      )
    end
  end
end
