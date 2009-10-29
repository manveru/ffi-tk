require 'ffi-tk/tcl/obj'
require 'ffi-tk/tcl/interp'
require 'ffi-tk/tcl/cmd_proc'
require 'ffi-tk/tcl/time'

module FFI
  module Tcl
    extend FFI::Library
    ffi_lib 'libtcl8.5.so', 'tcl85.dll', 'Tcl', 'libtcl'

    attach_function :Tcl_CreateInterp, [], Interp
    attach_function :Tcl_DeleteInterp, [Interp], :void
    attach_function :Tcl_DoOneEvent, [flags = :int], :int
    # attach_function :Tcl_Eval, [Interp, script = :string], :int
    attach_function :Tcl_EvalEx, [Interp, script = :string, length = :int, flags = :int], :int
    attach_function :Tcl_GetBooleanFromObj, [Interp, Obj, boolean = :pointer], :int
    attach_function :Tcl_GetIntFromObj, [Interp, Obj, int = :pointer], :int
    attach_function :Tcl_GetObjResult, [Interp], Obj
    attach_function :Tcl_GetObjType, [:string], ObjType
    attach_function :Tcl_GetString, [Obj], :string
    attach_function :Tcl_GetStringFromObj, [Obj, length = :pointer], :string
    attach_function :Tcl_GetStringResult, [Interp], :string
    attach_function :Tcl_GetUnicode, [Obj], :string
    attach_function :Tcl_Init, [Interp], :int
    attach_function :Tcl_ListObjGetElements, [Interp, Obj, count = :pointer, list = :pointer], :int
    attach_function :Tcl_ListObjIndex, [Interp, list = :pointer, index = :int, result = :pointer], :int
    attach_function :Tcl_ListObjLength, [Interp, list = :pointer, int = :pointer], :int
    attach_function :Tcl_NewListObj, [count = :int, values = :pointer], Obj
    attach_function :Tcl_WaitForEvent, [TclTime], :int
    attach_function :Tcl_AppendAllObjTypes, [Interp, Obj], :int

    callback :obj_cmd_proc, [:int, Interp, :int, :pointer], :int
    callback :obj_delete_proc, [:int], :void
    attach_function :Tcl_CreateObjCommand, [
      Interp, name = :string, :obj_cmd_proc, :int, :obj_delete_proc], :pointer

    class << self
      alias create_obj_command Tcl_CreateObjCommand
      alias append_all_obj_types Tcl_AppendAllObjTypes
      alias create_interp Tcl_CreateInterp
      alias delete_interp Tcl_DeleteInterp
      alias do_one_event Tcl_DoOneEvent
      # alias eval Tcl_Eval
      alias eval_ex Tcl_EvalEx
      alias get_boolean_from_obj Tcl_GetBooleanFromObj
      alias get_int_from_obj Tcl_GetIntFromObj
      alias get_obj_result Tcl_GetObjResult
      alias get_obj_type Tcl_GetObjType
      alias get_string Tcl_GetString
      alias get_string_from_obj Tcl_GetStringFromObj
      alias get_string_result Tcl_GetStringResult
      alias get_unicode Tcl_GetUnicode
      alias init Tcl_Init
      alias list_obj_get_elements Tcl_ListObjGetElements
      alias list_obj_index Tcl_ListObjIndex
      alias list_obj_length Tcl_ListObjLength
      alias new_list_obj Tcl_NewListObj
      alias wait_for_event Tcl_WaitForEvent
    end

    module_function

    def init(interp)
      if Tcl_Init(interp) == 1
        message = FFI::Tcl.Tcl_GetStringResult(interp)
        raise RuntimeError, message
      end
    end

    def list_map_string(interp, list)
      result_pointer = FFI::MemoryPointer.new(:pointer)
      count_pointer  = FFI::MemoryPointer.new(:int)
      length_pointer = FFI::MemoryPointer.new(:int)

      FFI::Tcl.list_obj_length(interp, list, count_pointer)
      count = count_pointer.get_int(0)

      (0...count).map do |idx|
        FFI::Tcl.list_obj_index(interp, list, idx, result_pointer)
        element_pointer = result_pointer.get_pointer(0)
        value = FFI::Tcl.get_string_from_obj(element_pointer, length_pointer)
        block_given? ? yield(value) : value
      end
    end
  end
end