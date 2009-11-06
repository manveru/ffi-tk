require 'ffi'

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'ffi-tk/ffi/tcl'
require 'ffi-tk/ffi/tk'

module Tk
  Error = Class.new(RuntimeError)
  OK = 0
  ERROR = 1
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