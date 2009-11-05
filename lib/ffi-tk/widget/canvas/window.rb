module Tk
  class Canvas
    # Items of type window cause a particular window to be displayed at a given
    # position on the canvas.
    class Window < Item
      options(
        :state, :tags, :anchor, :height, :width, :window
      )
    end
  end
end