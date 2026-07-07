# frozen_string_literal: true

module Tk
  class Canvas
    # A text item displays a string of characters on the screen in one or more
    # lines. [Canvas::Text] items support indexing and selection, along with the
    # following text-related [Canvas] methods: [Canvas.dchars], [Canvas.focus],
    # [Canvas.icursor], and [Canvas.index].
    class Text < Item
      # Types from canvas(3tk) TEXT ITEMS. -underline is an integer character
      # index (:integer, unlike the text *widget* tag's boolean -underline);
      # -angle is :float degrees; -justify/-anchor/-state keyword sets (:symbol);
      # -width the wrap length and -offset the stipple origin, both lossless
      # :string. -offset is reported by Tk though the man page's text section
      # omits it (unlike -angle, which the man page does document), so it is
      # declared here explicitly.
      item_options(
        activefill: :color, activestipple: :bitmap, anchor: :symbol,
        angle: :float, disabledfill: :color, disabledstipple: :bitmap,
        fill: :color, font: :font, justify: :symbol, offset: :string,
        state: :symbol, stipple: :bitmap, tags: :list, text: :string,
        underline: :integer, width: :string
      )
    end
  end
end
