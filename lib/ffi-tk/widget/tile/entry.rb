# frozen_string_literal: true

module Tk
  module Tile
    # A themed single-line text entry.
    # Wraps Tk's `ttk::entry`.
    class Entry < Tk::Entry
      def self.tk_command
        'ttk::entry'
      end
      include TileWidget
    end
  end
end
