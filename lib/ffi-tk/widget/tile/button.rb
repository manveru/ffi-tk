module Tk::Tile
  class Button < Tk::Button
    include Tk::Tile::TileWidget

    def initialize(parent, options = {}, &block)
      init_ttk_widget(parent, options, block, 'ttk::button')
    end
  end
end

