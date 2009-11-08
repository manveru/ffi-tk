module Tk::Tile
  class Scrollbar < Tk::Scrollbar
    INITIALIZE_COMMAND = 'ttk::scrollbar'
    include Tk::Tile::TileWidget

    def initialize(parent = Tk.root, options = None)
      options = scrollbar_default(options)
      super
    end

    def scrollbar_default(options)
      options
    end
  end

  class YScrollbar < Tk::Scrollbar
    def scrollbar_default(options)
      { :orient => 'vertical' }.merge(options)
    end
  end

  class XScrollbar < Tk::Scrollbar
    def scrollbar_default(options)
      { :orient => 'horizontal' }.merge(options)
    end
  end
end

