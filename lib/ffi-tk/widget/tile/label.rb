# frozen_string_literal: true
module Tk
  module Tile
    class Label < Tk::Label
      def self.tk_command
        'ttk::label'
      end
      include TileWidget
    end
  end
end
