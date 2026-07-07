# frozen_string_literal: true

module Tk
  class Canvas
    # Items of type arc appear on the display as arc-shaped regions.
    # An arc is a section of an oval delimited by two angles (specified by the
    # :start and :extent options) and displayed in one of several ways
    # (specified by the :style option).
    class Arc < Item
      # Types from canvas(3tk) ARC ITEMS + COMMON ITEM OPTIONS. Dash patterns
      # and coordinate/screen-distance specs (-dash, -dashoffset, -offset,
      # -outlineoffset, -width group) stay lossless :string; -extent/-start are
      # :float degrees; -style/-state are keyword sets (:symbol).
      item_options(
        dash: :string, activedash: :string, disableddash: :string,
        dashoffset: :string, fill: :color, activefill: :color,
        disabledfill: :color, offset: :string, outline: :color,
        activeoutline: :color, disabledoutline: :color, outlineoffset: :string,
        outlinestipple: :bitmap, activeoutlinestipple: :bitmap,
        disabledoutlinestipple: :bitmap, stipple: :bitmap,
        activestipple: :bitmap, disabledstipple: :bitmap, state: :symbol,
        tags: :list, width: :string, activewidth: :string,
        disabledwidth: :string, extent: :float, start: :float, style: :symbol
      )
    end
  end
end
