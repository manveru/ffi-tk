# frozen_string_literal: true

module Tk
  class Canvas
    # Items of type bitmap appear on the display as images with two colors,
    # foreground and background.
    class Bitmap < Item
      # Types from canvas(3tk) BITMAP ITEMS. The background/foreground groups
      # are all :color (Tk reports them as colours, unlike the legacy map which
      # miscalled the active/disabled variants :bitmap); -bitmap group is
      # :bitmap; -anchor/-state are keyword sets (:symbol).
      item_options(
        state: :symbol, tags: :list, anchor: :symbol, background: :color,
        activebackground: :color, disabledbackground: :color, bitmap: :bitmap,
        activebitmap: :bitmap, disabledbitmap: :bitmap, foreground: :color,
        activeforeground: :color, disabledforeground: :color
      )
    end
  end
end
