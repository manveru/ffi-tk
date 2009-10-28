require 'ffi-tk/tcl/interp'
require 'ffi-tk/tcl/time'
require 'ffi-tk/tcl/obj'

module FFI
  module Tcl
    extend FFI::Library
    ffi_lib 'libtcl8.5.so', 'tcl85.dll', 'Tcl', 'libtcl'

    attach_function :Tcl_CreateInterp, [], Interp
    attach_function :Tcl_DeleteInterp, [Interp], :void
    attach_function :Tcl_Init, [Interp], :int
    attach_function :Tcl_Eval, [Interp, script = :string], :int
    attach_function :Tcl_EvalEx, [Interp, script = :string, length = :int, flags = :int], :int
    attach_function :Tcl_GetStringResult, [Interp], :string
    attach_function :Tcl_WaitForEvent, [TclTime], :int
    attach_function :Tcl_DoOneEvent, [flags = :int], :int
    attach_function :Tcl_GetObjResult, [Interp], Obj
    attach_function :Tcl_GetUnicode, [Obj], :string

    #  char * Tcl_GetStringFromObj(objPtr, lengthPtr)
    attach_function :Tcl_GetStringFromObj, [Obj, length = :pointer], :string

#     callback :command_proc, 
#     attach_function :Tcl_CreateObjCommand, [Interp, cmdName, Proc, ClientData, DeleteProc], :pointer
#     Tcl_Command Tcl_CreateObjCommand(interp, cmdName, proc, clientData, deleteProc)

    class << self
      alias create_interp Tcl_CreateInterp
      alias delete_interp Tcl_DeleteInterp
      alias do_one_event Tcl_DoOneEvent
      alias eval Tcl_Eval
      alias eval_ex Tcl_EvalEx
      alias get_obj_result Tcl_GetObjResult
      alias get_string_from_obj Tcl_GetStringFromObj
      alias get_string_result Tcl_GetStringResult
      alias get_unicode Tcl_GetUnicode
      alias init Tcl_Init
      alias wait_for_event Tcl_WaitForEvent
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