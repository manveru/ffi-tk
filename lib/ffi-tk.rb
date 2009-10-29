require 'ffi'

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'ffi-tk/ffi/tcl'
require 'ffi-tk/ffi/tk'

module Tk
  Error = Class.new(RuntimeError)
  None = Object.new
  OK = 0
  ERROR = 1

  autoload :Bind,       'ffi-tk/command/bind'
  autoload :Button,     'ffi-tk/widget/button'
  autoload :Destroy,    'ffi-tk/command/destroy'
  autoload :Entry,      'ffi-tk/widget/entry'
  autoload :EvalResult, 'ffi-tk/eval_result'
  autoload :Event,      'ffi-tk/event'
  autoload :Pack,       'ffi-tk/command/pack'
  autoload :Root,       'ffi-tk/widget/root'
  autoload :Text,       'ffi-tk/widget/text'
  autoload :Widget,     'ffi-tk/widget'

  # Don't autoload this, or find out why it segfaults
  require 'ffi-tk/command/cget'
  require 'ffi-tk/command/focus'

  # require the real thing
  require 'ffi-tk/tk'
end