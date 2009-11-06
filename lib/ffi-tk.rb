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

  autoload :Button,       'ffi-tk/widget/button'
  autoload :Canvas,       'ffi-tk/widget/canvas'
  autoload :Entry,        'ffi-tk/widget/entry'
  autoload :Frame,        'ffi-tk/widget/frame'
  autoload :Root,         'ffi-tk/widget/root'
  autoload :Text,         'ffi-tk/widget/text'
  autoload :Widget,       'ffi-tk/widget'
  autoload :Label,        'ffi-tk/widget/label'

  # Don't autoload this, or find out why it segfaults
  require 'ffi-tk/event/data'
  require 'ffi-tk/event/handler'
  require 'ffi-tk/command'
  require 'ffi-tk/variable'

  # require the real thing
  require 'ffi-tk/tk'
end