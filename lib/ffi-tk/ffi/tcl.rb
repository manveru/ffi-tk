require 'ffi-tk/ffi/tcl/obj'
require 'ffi-tk/ffi/tcl/interp'
require 'ffi-tk/ffi/tcl/cmd_proc'
require 'ffi-tk/ffi/tcl/time'
require 'ffi-tk/ffi/tcl/eval_result'

module FFI
  module Tcl
    extend FFI::Library
    ffi_lib 'libtcl8.5.so', 'tcl85.dll', 'Tcl', 'libtcl'

    attach_function :Tcl_AppendAllObjTypes, [Interp, Obj], :int
    attach_function :Tcl_CreateInterp, [], Interp
    attach_function :Tcl_DeleteInterp, [Interp], :void
    attach_function :Tcl_DoOneEvent, [flags = :int], :int
    attach_function :Tcl_EvalEx, [Interp, script = :string, length = :int, flags = :int], :int
    attach_function :Tcl_GetBoolean, [Interp, :string, :pointer], :int
    attach_function :Tcl_GetBooleanFromObj, [Interp, Obj, boolean = :pointer], :int
    attach_function :Tcl_GetDoubleFromObj, [Interp, Obj, :pointer], :int
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
    attach_function :Tcl_NewBooleanObj, [:int], Obj
    attach_function :Tcl_NewIntObj, [:int], Obj
    attach_function :Tcl_NewListObj, [count = :int, values = :pointer], Obj
    attach_function :Tcl_NewStringObj, [:string, :int], Obj
    attach_function :Tcl_ObjGetVar2, [Interp, :pointer, :pointer, :int], Obj
    attach_function :Tcl_ObjSetVar2, [Interp, Obj, Obj, Obj, :int], Obj
    attach_function :Tcl_ParseVar, [Interp, :pointer, :pointer], :pointer
    attach_function :Tcl_SetObjResult, [Interp, Obj], :void
    attach_function :Tcl_WaitForEvent, [TclTime], :int

    callback :obj_cmd_proc, [:int, Interp, :int, :pointer], :int
    callback :obj_delete_proc, [:int], :void
    attach_function :Tcl_CreateObjCommand, [
      Interp, name = :string, :obj_cmd_proc, :int, :obj_delete_proc], :pointer

    debug_code = <<-RUBY
def self.%s(*args, &block)
  @thread_sender.thread_send{
    p Thread.current.object_id => [:%s, args]
    p %s(*args, &block)
  }
end
    RUBY

    fast_code = <<-RUBY
def self.%s(*args, &block)
  @thread_sender.thread_send{ %s(*args, &block) }
end
    RUBY

    singleton_methods.grep(/^Tcl_/).each do |function|
      ruby_name = function.to_s.gsub(/([A-Z][a-z]+)/, '_\1').sub('_Tcl__', '').downcase
      if $DEBUG
        eval(debug_code % [ruby_name, function, function])
      else
        eval(fast_code % [ruby_name, function])
      end
    end

    module_function

    @thread_sender = ThreadSender.new

    def thread_send(&block)
      @thread_sender.thread_send(&block)
    end

    def create_interp
      thread_send{ Tcl.Tcl_CreateInterp }
    end

    def init(interp)
      thread_send do
        if Tcl_Init(interp) == 1
          message = get_string_result(interp)
          raise RuntimeError, message
        end
      end
    end

    def get_boolean(interp, ruby_object)
      thread_send do
        boolean_pointer = MemoryPointer.new(:int)
        Tcl_GetBoolean(interp, ruby_object.to_s, boolean_pointer)
        boolean_pointer.get_int(0) == 1
      end
    end

    def list_map_string(interp, list)
      result_pointer = MemoryPointer.new(:pointer)
      count_pointer  = MemoryPointer.new(:int)
      length_pointer = MemoryPointer.new(:int)

      thread_send do
        Tcl_ListObjLength(interp, list, count_pointer)
        count = count_pointer.get_int(0)

        (0...count).map do |idx|
          Tcl_ListObjIndex(interp, list, idx, result_pointer)
          element_pointer = result_pointer.get_pointer(0)
          value = Tcl_GetStringFromObj(element_pointer, length_pointer)
          block_given? ? yield(value) : value
        end
      end
    end
  end
end
