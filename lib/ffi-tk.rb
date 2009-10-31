require 'ffi'

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'ffi-tk/ffi/tcl'
require 'ffi-tk/ffi/tk'

module Tk
  Error = Class.new(RuntimeError)
  None = Object.new
  OK = 0
  ERROR = 1

  autoload :Button,       'ffi-tk/widget/button'
  autoload :Entry,        'ffi-tk/widget/entry'
  autoload :Root,         'ffi-tk/widget/root'
  autoload :Text,         'ffi-tk/widget/text'
  autoload :Widget,       'ffi-tk/widget'

  # Don't autoload this, or find out why it segfaults
  require 'ffi-tk/event/data'
  require 'ffi-tk/event/handler'
  require 'ffi-tk/command'

  # require the real thing
  require 'ffi-tk/tk'
end