module Tk::Tile
  class MenuButton < Tk::MenuButton
    include Tk::Tile::TileWidget

    def initialize(parent, options = {}, &block)
      init_ttk_widget(parent, options, block, 'ttk::menubutton')
    end
  end
end

