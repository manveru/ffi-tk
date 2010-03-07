require 'thread'
require 'ffi'

$LOAD_PATH.unshift File.dirname(__FILE__)

module Tk
  LIBPATH = {
    tcl: ENV['TCL_LIBPATH'].to_s.split(':'),
    tk:  ENV[ 'TK_LIBPATH'].to_s.split(':'),
  }

  LIBPATH[:tcl] << 'tcl' << 'tcl85' << 'tcl8.5'
  LIBPATH[:tk ] <<  'tk' <<  'tk85' <<  'tk8.5'

  if FFI::Platform.mac?
    if ENV['NO_AQUA'] || ENV['USE_X11'] # macports-x11 libtk
      LIBPATH[:tcl] << '/opt/local/lib/libtcl8.5.dylib'
      LIBPATH[:tk] << '/opt/local/lib/libtk8.5.dylib'
    else # Tcl/Tk Aqua >= 8.5
      LIBPATH[:tcl] << '/Library/Frameworks/Tcl.framework/Tcl'
      LIBPATH[:tk] << '/Library/Frameworks/Tk.framework/Tk'
    end
  end

  unless const_defined?(:RUN_EVENTLOOP_ON_MAIN_THREAD)
    if FFI::Platform.mac?
      # In some cases Tk has trouble running, this seems to happen on windows and
      # OSX/TkAqua mostly.
      # In these cases please use:
      #   module Tk; RUN_EVENTLOOP_ON_MAIN_THREAD = true; end
      # before you require 'tk'
      RUN_EVENTLOOP_ON_MAIN_THREAD = true
    else
      RUN_EVENTLOOP_ON_MAIN_THREAD = false
    end
  end

  DONT_WAIT     = 1 << 1
  WINDOW_EVENTS = 1 << 2
  FILE_EVENTS   = 1 << 3
  TIMER_EVENTS  = 1 << 4
  IDLE_EVENTS   = 1 << 5
  ALL_EVENTS    = ~DONT_WAIT

  OK       = 0
  ERROR    = 1
  RETURN   = 2
  BREAK    = 3
  CONTINUE = 4

  Error = Class.new(RuntimeError)
  None = Object.new

  class << None
    def to_tcl; nil; end
    def to_tcl_options?; self; end
    def to_tcl_option?; self; end
    def inspect; '#<None>'; end
  end
end

require 'ffi-tk/thread_sender'
require 'ffi-tk/ffi/tcl'
require 'ffi-tk/ffi/tk'

module Tk
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
