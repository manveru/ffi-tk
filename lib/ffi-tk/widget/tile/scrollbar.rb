# frozen_string_literal: true

module Tk
  module Tile
    # A themed scrollbar.
    # Wraps Tk's `ttk::scrollbar`.
    class Scrollbar < Tk::Scrollbar
      def self.tk_command
        'ttk::scrollbar'
      end
      include TileWidget

      def initialize(parent = Tk.root, options = {})
        super
        scrollbar_default
      end

      # Orientation preset hook for the YScrollbar/XScrollbar subclasses; the
      # base themed scrollbar keeps ttk's default. orient/command are inherited
      # from Tk::Scrollbar and dispatch through this widget's configure/cget.
      def scrollbar_default; end
    end

    # A themed scrollbar preset to vertical orientation.
    class YScrollbar < Tk::Tile::Scrollbar
      def scrollbar_default
        configure orient: :vertical
      end
    end

    # A themed scrollbar preset to horizontal orientation.
    class XScrollbar < Tk::Tile::Scrollbar
      def scrollbar_default
        configure orient: :horizontal
      end
    end
  end
end
