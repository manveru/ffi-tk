module Tk
  module Tile
    class RadioButton < Tk::RadioButton
      def self.tk_command; 'ttk::radiobutton'; end
      include TileWidget
    end
  end
end
