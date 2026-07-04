# frozen_string_literal: true

module Tk
  module Tile
    # A themed mutually-exclusive choice button.
    # Wraps Tk's `ttk::radiobutton`.
    class RadioButton < Tk::RadioButton
      def self.tk_command
        'ttk::radiobutton'
      end
      include TileWidget
    end
  end
end
