module Tk::Tile
  class RadioButton < Tk::RadioButton
    include Tk::Tile::TileWidget

    def initialize(parent, options = {}, &block)
      init_ttk_widget(parent, options, block, 'ttk::radiobutton')
    end
  end
end

