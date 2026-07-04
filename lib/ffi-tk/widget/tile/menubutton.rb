# frozen_string_literal: true

module Tk
  module Tile
    # A themed button that posts a menu.
    # Wraps Tk's `ttk::menubutton`.
    class MenuButton < Tk::MenuButton
      def self.tk_command
        'ttk::menubutton'
      end
      include TileWidget
    end
  end
end
