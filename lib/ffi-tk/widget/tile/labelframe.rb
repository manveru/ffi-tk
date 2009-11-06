module Tk::Tile
  class LabelFrame < Tk::LabelFrame
    include Tk::Tile::TileWidget

    def initialize(parent, options = {}, &block)
      init_ttk_widget(parent, options, block, 'ttk::labelframe')
    end
  end
end

