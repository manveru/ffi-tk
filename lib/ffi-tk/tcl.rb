require 'ffi-tk/tcl/interp'
require 'ffi-tk/tcl/time'

module FFI
  module Tcl
    extend FFI::Library
    ffi_lib 'libtcl8.5.so', 'tcl85.dll', 'Tcl', 'libtcl'

    attach_function :Tcl_CreateInterp, [], Interp
    attach_function :Tcl_DeleteInterp, [Interp], :void
    attach_function :Tcl_Init, [Interp], :int
    attach_function :Tcl_Eval, [Interp, :string], :int
    attach_function :Tcl_EvalEx, [Interp, :string, :int, :int], :int
    attach_function :Tcl_GetStringResult, [Interp], :string
    attach_function :Tcl_WaitForEvent, [:pointer], :int
    attach_function :Tcl_DoOneEvent, [:int], :int

    class << self
      alias create_interp Tcl_CreateInterp
      alias delete_interp Tcl_DeleteInterp
      alias init Tcl_Init
      alias eval Tcl_Eval
      alias eval_ex Tcl_EvalEx
      alias get_string_result Tcl_GetStringResult
      alias wait_for_event Tcl_WaitForEvent
      alias do_one_event Tcl_DoOneEvent
    end

    module_function

    def init(interp)
      if Tcl_Init(interp) == 1
        message = FFI::Tcl.Tcl_GetStringResult(interp)
        raise RuntimeError, message
      end
    end
  end
end