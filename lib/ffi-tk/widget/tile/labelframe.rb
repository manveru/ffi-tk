# frozen_string_literal: true
module Tk
  module Tile
    class LabelFrame < Tk::LabelFrame
      def self.tk_command
        'ttk::labelframe'
      end
      include TileWidget
    end
  end
end
