module Tk::Tile
  class Scale < Tk::Scale
    INITIALIZE_COMMAND = 'ttk::scale'
    include Tk::Tile::TileWidget
  end

  class Progress < Tk::Progess
    def initialize(parent, options = {}, &block)
      INITIALIZE_COMMAND = 'ttk::progess'
      include Tk::Tile::TileWidget
    end
  end
end

