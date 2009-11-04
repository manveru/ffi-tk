module Tk
  class Canvas
    class Bitmap < Item
      options(
        :state, :tags, :anchor, :background, :activebackground,
        :disabledbackground, :bitmap, :activebitmap, :disabledbitmap,
        :foreground, :activeforeground, :disabledforeground
      )
    end
  end
end