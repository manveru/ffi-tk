# frozen_string_literal: true

module Tk
  module Tile
    # A themed push button.
    # Wraps Tk's `ttk::button`.
    class Button < Tk::Button
      def self.tk_command
        'ttk::button'
      end
      include TileWidget
    end
  end
end
