# frozen_string_literal: true
module Tk
  class Canvas
    # Items of type image are used to display images on a canvas.
    class Image < Item
      options(
        :state, :tags, :anchor, :image, :activeimage, :disabledimage
      )
    end
  end
end
