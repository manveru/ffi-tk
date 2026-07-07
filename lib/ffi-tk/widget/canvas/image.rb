# frozen_string_literal: true

module Tk
  class Canvas
    # Items of type image are used to display images on a canvas.
    class Image < Item
      # Types from canvas(3tk) IMAGE ITEMS. The -image group holds image names
      # (:string, matching the text widget's embedded-image schema);
      # -anchor/-state are keyword sets (:symbol).
      item_options(
        state: :symbol, tags: :list, anchor: :symbol, image: :string,
        activeimage: :string, disabledimage: :string
      )
    end
  end
end
