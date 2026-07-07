# frozen_string_literal: true

module Tk
  class Canvas
    # Items of type rectangle appear as rectangular regions on the display.
    # Each rectangle may have an outline, a fill, or both.
    class Rectangle < Item
      # Types from canvas(3tk) RECTANGLE ITEMS (the full COMMON ITEM OPTIONS
      # set): colours for the fill/outline groups, :bitmap for the stipples,
      # keyword :symbol for -state, lossless :string for dash/offset/width specs.
      item_options(
        dash: :string, activedash: :string, disableddash: :string,
        dashoffset: :string, fill: :color, activefill: :color,
        disabledfill: :color, offset: :string, outline: :color,
        activeoutline: :color, disabledoutline: :color, outlineoffset: :string,
        outlinestipple: :bitmap, activeoutlinestipple: :bitmap,
        disabledoutlinestipple: :bitmap, stipple: :bitmap,
        activestipple: :bitmap, disabledstipple: :bitmap, state: :symbol,
        tags: :list, width: :string, activewidth: :string,
        disabledwidth: :string
      )
    end
  end
end
