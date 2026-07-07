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
      # (:list); -smooth is a genuine :boolean (bezier/raw read back as true);
      # -splinesteps a positive :integer; -offset (which Tk reports here though
      # the man page omits it) and the width/dash specs stay lossless :string.
      item_options(
        dash: :string, activedash: :string, disableddash: :string,
        dashoffset: :string, fill: :color, activefill: :color,
        disabledfill: :color, offset: :string, stipple: :bitmap,
        activestipple: :bitmap, disabledstipple: :bitmap, state: :symbol,
        tags: :list, width: :string, activewidth: :string,
        disabledwidth: :string, arrow: :symbol, arrowshape: :list,
        capstyle: :symbol, joinstyle: :symbol, smooth: :boolean,
        splinesteps: :integer
      )
    end
  end
end
