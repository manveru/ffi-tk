# frozen_string_literal: true
module Tk
  module Tile
    class Scrollbar < Tk::Scrollbar
      def self.tk_command
        'ttk::scrollbar'
      end
      include TileWidget

      def initialize(parent = Tk.root, options = {})
        super
        scrollbar_default
      end

      # Specifies the orientation of the scrollbar.
      # horizontal or vertical
      def orient(orientation = None)
        if None == orientation
          cget(:orient)
        else
          configure orient: orientation
        end
      end

      def command(&block)
        configure(command: block) if block
      end
    end

    class YScrollbar < Tk::Tile::Scrollbar
      def scrollbar_default
        configure orient: :vertical
      end
    end

    class XScrollbar < Tk::Tile::Scrollbar
      def scrollbar_default
        configure orient: :horizontal
      end
    end
  end
end
