# frozen_string_literal: true
module Tk
  module Tile
    class CheckButton < Tk::CheckButton
      def self.tk_command
        'ttk::checkbutton'
      end
      include TileWidget
    end
  end
end
