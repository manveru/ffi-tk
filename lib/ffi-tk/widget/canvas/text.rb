# frozen_string_literal: true
module Tk
  class Canvas
    # A text item displays a string of characters on the screen in one or more
    # lines. [Canvas::Text] items support indexing and selection, along with the
    # following text-related [Canvas] methods: [Canvas.dchars], [Canvas.focus],
    # [Canvas.icursor], and [Canvas.index].
    class Text < Item
      options(
        :activefill, :activestipple, :anchor, :disabledfill, :disabledstipple,
        :fill, :font, :justify, :state, :stipple, :tags, :text, :underline,
        :width
      )
    end
  end
end
