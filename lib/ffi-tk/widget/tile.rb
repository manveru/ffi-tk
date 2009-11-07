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
      def initialize(parent = Tk.root, options = None)
        if options.respond_to?(:values_at)
          style_spec = options.values_at(:style)
          options.delete(:style)
        end

        super

        Tk::Tile::Style.layout(style_spec, tk_pathname) if style_spec
      end

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
        grid_configure options.to_tcl_options
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

    autoload :Style,         'ffi-tk/widget/tile/style'

  end
end

#Ttk = Tk::Tile
__END__

    def self.load_images(imgdir, pat=nil)
      pat ||= '*.gif'
      pat = pat.kind_of?(Array) ? pat : [pat]

      Dir.chdir(imgdir){
        pat_list.each{|pat|
          Dir.glob(pat).each{|f|
            img = File.basename(f, '.*')
            #unless TkComm.bool(Tk.info('exists', "images(#{img})"))
            unless Tk.execute('info', 'exists', "images(#{img})")
              tk_image = Tk.execute('image', 'create', 'photo', '-file', f)
              Tk.execute('set', "images(#{img})", tk_image)
            end
          }
        }
      }
      images = Hash[*Tk.execute('array', 'get', 'images')]
      images.keys.each{|k|
        images[k] = TkPhotoImage.new(:imagename=>images[k],
                                     :without_creating=>true)
      }

      images
    end


    def self.themes(glob_ptn = nil)
      glob_ptn = '*' unless glob_ptn
      cmd = ['::ttk::themes', glob_ptn]
      begin
        Tk.execute(*cmd)
      rescue
        Tk.execute('lsearch', '-all', '-inline', Style.theme_names, glob_ptn)
      end
    end

