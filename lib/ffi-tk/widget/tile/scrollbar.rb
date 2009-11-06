module Tk::Tile
  class Scrollbar < Tk::Scrollbar
    include Tk::Tile::TileWidget

    def initialize(parent, options = {}, &block)
      scrollbar_defaults(options)

      init_ttk_widget(parent, options, block, 'ttk::scrollbar')
    end

    def scrollbar_defaults(options{})
      options
    end
  end

  class YScrollbar < Tk::Scrollbar
    include Tk::Tile::TileWidget

    def scrollbar_defaults(options={})
      { :orient => 'vertical' }.merge(options)
    end
  end

  class XScrollbar < Tk::Scrollbar
    include Tk::Tile::TileWidget

    def scrollbar_defaults(options={})
      { :orient => 'horizontal' }.merge(options)
    end
  end
end

