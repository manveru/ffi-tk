# frozen_string_literal: true

module Tk
  class Canvas
    # Items of type window cause a particular window to be displayed at a given
    # position on the canvas.
    class Window < Item
      # Types from canvas(3tk) WINDOW ITEMS. -window names the embedded widget
      # (:pathname, resolved to the Widget object, matching the text widget's
      # embedded-window schema); -height/-width are screen distances (lossless
      # :string); -anchor/-state keyword sets (:symbol).
      item_options(
        state: :symbol, tags: :list, anchor: :symbol, height: :string,
        width: :string, window: :pathname
      )
    end
  end
end
