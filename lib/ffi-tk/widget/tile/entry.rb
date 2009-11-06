module Tk::Tile
  class Entry < Tk::Entry
    include Tk::Tile::TileWidget

    def initialize(parent, options = {}, &block)
      init_ttk_widget(parent, options, block, 'ttk::entry')
    end
  end
end

