# frozen_string_literal: true

module Tk
  module Tile
    # A themed display for text or an image.
    # Wraps Tk's `ttk::label`.
    class Label < Tk::Label
      def self.tk_command
        'ttk::label'
      end
      include TileWidget
    end
  end
end
