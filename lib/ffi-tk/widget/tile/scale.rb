# frozen_string_literal: true

module Tk
  module Tile
    # A themed slider for a numeric range.
    # Wraps Tk's `ttk::scale`.
    class Scale < Tk::Scale
      def self.tk_command
        'ttk::scale'
      end
      include TileWidget
    end
  end
end
