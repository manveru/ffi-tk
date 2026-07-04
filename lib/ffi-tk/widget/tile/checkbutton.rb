# frozen_string_literal: true

module Tk
  module Tile
    # A themed on/off toggle with a label.
    # Wraps Tk's `ttk::checkbutton`.
    class CheckButton < Tk::CheckButton
      def self.tk_command
        'ttk::checkbutton'
      end
      include TileWidget
    end
  end
end
