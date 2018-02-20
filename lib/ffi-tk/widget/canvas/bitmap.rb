# frozen_string_literal: true
module Tk
  class Canvas
    # Items of type bitmap appear on the display as images with two colors,
    # foreground and background.
    class Bitmap < Item
      options(
        :state, :tags, :anchor, :background, :activebackground,
        :disabledbackground, :bitmap, :activebitmap, :disabledbitmap,
        :foreground, :activeforeground, :disabledforeground
      )
    end
  end
end
