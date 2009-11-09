module Tk::Tile
  class Scale < Tk::Scale
    def self.tk_command; 'ttk::scale'; end
    include Tk::Tile::TileWidget
  end

  class Progress < Tk::Progess
    def initialize(parent, options = {}, &block)
      def self.tk_command; 'ttk::progess'; end
      include Tk::Tile::TileWidget
    end
  end
end

