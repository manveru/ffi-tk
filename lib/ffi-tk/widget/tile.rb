# Ttk package merged Tcl/Tk core (Tcl/Tk 8.5+)
module Tk
  module Tile
    TILE_SPEC_VERSION_ID = 8
    PACKAGE_NAME = 'Ttk'.freeze

    def self.style(style, parent_name)
      Style.style(style, parent_name)
    end

    def self.set_theme(theme)
      Style.theme_use(theme)
    end

    # TileWidget module shared common tile methods
    module TileWidget
      def ttk_state(new_state = None)
        if new_state == None
          execute(:state).to_a
        else
          execute_only(:state, new_state)
        end
      end

      def state(new_state = None)
        ttk_state(new_state)
      end

      #def identify(x, y)
      #  ret = execute('identify', x, y)
      #  (ret.empty?)? nil: ret
      #end

      def style(layout_spec, name = tk_pathname)
        Tk::Tile::Style.layout(name, layout_spec)
      end

      include Tk::Grid

      def grid(options)
        grid_configure options
      end
    end

    module Font
      Default      = 'TkDefaultFont'
      Text         = 'TkTextFont'
      Heading      = 'TkHeadingFont'
      Caption      = 'TkCaptionFont'
      Tooltip      = 'TkTooltipFont'
      Fixed        = 'TkFixedFont'
      Menu         = 'TkMenuFont'
      SmallCaption = 'TkSmallCaptionFont'
      Icon         = 'TkIconFont'
    end


    ######################################
    autoload :Entry,         'ffi-tk/widget/tile/entry'
    autoload :Frame,         'ffi-tk/widget/tile/frame'
    autoload :Button,        'ffi-tk/widget/tile/button'
    autoload :LabelFrame,    'ffi-tk/widget/tile/labelframe'
    autoload :CheckButton,   'ffi-tk/widget/tile/checkbutton'
    autoload :RadioButton,   'ffi-tk/widget/tile/radiobutton'
    autoload :MenuButton,    'ffi-tk/widget/tile/menubutton'
    autoload :PanedWindow,   'ffi-tk/widget/tile/panedwindow'
    autoload :Label,         'ffi-tk/widget/tile/label'
    autoload :Scale,         'ffi-tk/widget/tile/scale'
    autoload :Scrollbar,     'ffi-tk/widget/tile/scrollbar'
    autoload :YScrollbar,    'ffi-tk/widget/tile/scrollbar'
    autoload :XScrollbar,    'ffi-tk/widget/tile/scrollbar'

    autoload :Style,         'ffi-tk/widget/tile/style'

  end
end

#Ttk = Tk::Tile
