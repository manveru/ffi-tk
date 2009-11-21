require 'thread'
require 'ffi'

$LOAD_PATH.unshift File.dirname(__FILE__)

module Tk
  LIBPATH = { tcl: [], tk: [] }

  if ENV['Apple_PubSub_Socket_Render']
    RUN_EVENTLOOP_ON_MAIN_THREAD = true

    if ENV['NO_AQUA'] || ENV['USE_X11'] # macports-x11 libtk
      LIBPATH[:tcl] << '/opt/local/lib/libtcl8.5.dylib'
      LIBPATH[:tk] << '/opt/local/lib/libtk8.5.dylib'
    else # Tcl/Tk Aqua >= 8.5
      LIBPATH[:tcl] << '/Library/Frameworks/Tcl.framework/Tcl'
      LIBPATH[:tk] << '/Library/Frameworks/Tk.framework/Tk'
    end
  end
end

require 'ffi-tk/thread_sender'
require 'ffi-tk/ffi/tcl'
require 'ffi-tk/ffi/tk'

module Tk
  Error = Class.new(RuntimeError)

  OK       = 0
  ERROR    = 1
  RETURN   = 2
  BREAK    = 3
  CONTINUE = 4

  None = Object.new

  class << None
    def to_tcl; nil; end
    def to_tcl_options?; self; end
    def to_tcl_option?; self; end
    def inspect; '#<None>'; end
  end

  autoload :Button,      'ffi-tk/widget/button'
  autoload :Canvas,      'ffi-tk/widget/canvas'
  autoload :CheckButton, 'ffi-tk/widget/checkbutton'
  autoload :Entry,       'ffi-tk/widget/entry'
  autoload :Frame,       'ffi-tk/widget/frame'
  autoload :Label,       'ffi-tk/widget/label'
  autoload :LabelFrame,  'ffi-tk/widget/labelframe'
  autoload :Listbox,     'ffi-tk/widget/listbox'
  autoload :Menu,        'ffi-tk/widget/menu'
  autoload :MenuButton,  'ffi-tk/widget/menubutton'
  autoload :Message,     'ffi-tk/widget/message'
  autoload :PanedWindow, 'ffi-tk/widget/panedwindow'
  autoload :RadioButton, 'ffi-tk/widget/radiobutton'
  autoload :Root,        'ffi-tk/widget/root'
  autoload :Scale,       'ffi-tk/widget/scale'
  autoload :Scrollbar,   'ffi-tk/widget/scrollbar'
  autoload :Spinbox,     'ffi-tk/widget/spinbox'
  autoload :Text,        'ffi-tk/widget/text'
  autoload :Toplevel,    'ffi-tk/widget/toplevel'

  autoload :Tile,         'ffi-tk/widget/tile'

  require 'ffi-tk/core_extensions'
  require 'ffi-tk/geometry'
  require 'ffi-tk/event/data'
  require 'ffi-tk/event/handler'
  require 'ffi-tk/variable'
  require 'ffi-tk/command'
  require 'ffi-tk/widget'

  # require the real thing
  require 'ffi-tk/tk'
end
