module Tk::Tile
  class Label < Tk::Label
    include Tk::Tile::TileWidget

    def initialize(parent, options = {}, &block)
      init_ttk_widget(parent, options, block, 'ttk::label')
    end
  end
end

