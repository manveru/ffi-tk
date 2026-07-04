# frozen_string_literal: true

module Tk
  module Tile
    # A themed titled container.
    # Wraps Tk's `ttk::labelframe`.
    class LabelFrame < Tk::LabelFrame
      def self.tk_command
        'ttk::labelframe'
      end
      include TileWidget
    end
  end
end
