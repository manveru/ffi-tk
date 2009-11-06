module Tk::Tile
  class Scale < Tk::Scale
    include Tk::Tile::TileWidget

    def initialize(parent, options = {}, &block)
      init_ttk_widget(parent, options, block, 'ttk::scale')
    end
  end

  class Progress < Tk::Tile::Scale
    def initialize(parent, options = {}, &block)
      init_ttk_widget(parent, options, block, 'ttk::progress')
    end
  end
end

