# frozen_string_literal: true

module Tk
  class Canvas
    # Items of type oval appear as circular or oval regions on the display.
    # Each oval may have an outline, a fill, or both.
    class Oval < Item
      # Types from canvas(3tk) OVAL ITEMS (the full COMMON ITEM OPTIONS set):
      # colours for the fill/outline groups, :bitmap for the stipples, keyword
      # :symbol for -state, and lossless :string for the dash/offset/width specs.
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
