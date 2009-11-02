require 'ffi'

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'ffi-tk/ffi/tcl'
require 'ffi-tk/ffi/tk'

module Tk
  Error = Class.new(RuntimeError)
  OK = 0
  ERROR = 1
  None = Object.new
  def None.to_tcl; nil; end
  def None.inspect; '#<None>'; end

  autoload :Button,       'ffi-tk/widget/button'
  autoload :Entry,        'ffi-tk/widget/entry'
  autoload :Frame,        'ffi-tk/widget/frame'
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