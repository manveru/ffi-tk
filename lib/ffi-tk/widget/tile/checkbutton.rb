module Tk::Tile
  class CheckButton < Tk::CheckButton
    include Tk::Tile::TileWidget

    def initialize(parent, options = {}, &block)
      init_ttk_widget(parent, options, block, 'ttk::checkbutton')
    end
  end
end

