require 'ffi-tk/ffi/tcl/obj'
require 'ffi-tk/ffi/tcl/interp'
require 'ffi-tk/ffi/tcl/cmd_proc'
require 'ffi-tk/ffi/tcl/time'
require 'ffi-tk/ffi/tcl/eval_result'

module FFI
  module Tcl
    extend FFI::Library
    ffi_lib ::Tk::LIBPATH[:tcl]

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
    attach_function :Tcl_SetMaxBlockTime, [TclTime], :void

    callback :obj_cmd_proc, [:int, Interp, :int, :pointer], :int
    callback :obj_delete_proc, [:int], :void
    attach_function :Tcl_CreateObjCommand, [
      Interp, name = :string, :obj_cmd_proc, :int, :obj_delete_proc], :pointer

    module_function

    ATTACHED_FUNCTIONS = {}
    singleton_methods.grep(/^Tcl_/).each do |function|
      ruby_name = function.to_s.
        gsub(/([A-Z][a-z]+)/, '_\1').sub('_Tcl__', '').downcase
      ATTACHED_FUNCTIONS[function] = ruby_name
    end
    BINDING = binding

    def setup_eventloop_on_new_thread
      puts "Run eventloop on new thread" if $DEBUG

      code = <<-RUBY.strip
def self.%s(*args, &block)
  @thread_sender.thread_send{ %s(*args, &block) }
end
      RUBY

      binding, file, line = BINDING, __FILE__, __LINE__ - 5
      ATTACHED_FUNCTIONS.each do |function, ruby_name|
        eval(code % [ruby_name, function], binding, file, line)
      end

      @thread_sender = ThreadSender.new
      class << self; attr_reader :thread_sender; end
      @thread_sender.thread_send{ Interp.new(create_interp) }
    end

    def setup_eventloop_on_main_thread
      puts "Run eventloop on main thread" if $DEBUG

      code = <<-'RUBY'.strip
def self.%s(*args, &block)
  %s(*args, &block)
end
      RUBY

      binding, file, line = BINDING, __FILE__, __LINE__ - 5
      ATTACHED_FUNCTIONS.each do |function, ruby_name|
        eval(code % [ruby_name, function], binding, file, line)
      end

      Interp.new(create_interp)
    end
  end
end
