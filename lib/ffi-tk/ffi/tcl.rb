# frozen_string_literal: true
require 'ffi-tk/ffi/tcl/obj'
require 'ffi-tk/ffi/tcl/interp'
require 'ffi-tk/ffi/tcl/cmd_proc'
require 'ffi-tk/ffi/tcl/time'
require 'ffi-tk/ffi/tcl/eval_result'

module FFI
  module Tcl
    extend FFI::Library
    ffi_lib ::Tk::TCL_LIBPATH

    attach_function :Tcl_AppendAllObjTypes, [:pointer, :pointer], :int
    attach_function :Tcl_CreateInterp, [], :pointer
    attach_function :Tcl_DeleteInterp, [:pointer], :void
    attach_function :Tcl_DoOneEvent, [:int], :int
    attach_function :Tcl_EvalEx, [:pointer, :string, :int, :int], :int
    attach_function :Tcl_GetBoolean, [:pointer, :string, :pointer], :int
    attach_function :Tcl_GetBooleanFromObj, [:pointer, :pointer, :pointer], :int
    attach_function :Tcl_GetDoubleFromObj, [:pointer, :pointer, :pointer], :int
    attach_function :Tcl_GetIntFromObj, [:pointer, :pointer, :pointer], :int
    attach_function :Tcl_GetObjResult, [:pointer], :pointer
    attach_function :Tcl_GetObjType, [:string], :pointer
    attach_function :Tcl_GetString, [:pointer], :string
    attach_function :Tcl_GetStringFromObj, [:pointer, :pointer], :string
    attach_function :Tcl_GetStringResult, [:pointer], :string
    attach_function :Tcl_GetUnicode, [:pointer], :string
    attach_function :Tcl_Init, [:pointer], :int
    attach_function :Tcl_ListObjGetElements, [:pointer, :pointer, :pointer, :pointer], :int
    attach_function :Tcl_ListObjIndex, [:pointer, :pointer, :int, :pointer], :int
    attach_function :Tcl_ListObjLength, [:pointer, :pointer, :pointer], :int
    attach_function :Tcl_NewBooleanObj, [:int], :pointer
    attach_function :Tcl_NewIntObj, [:int], :pointer
    attach_function :Tcl_NewListObj, [:int, :pointer], :pointer
    attach_function :Tcl_NewStringObj, [:string, :int], :pointer
    attach_function :Tcl_NewDictObj, [], :pointer
    attach_function :Tcl_ObjGetVar2, [:pointer, :pointer, :pointer, :int], :pointer
    attach_function :Tcl_ObjSetVar2, [:pointer, :pointer, :pointer, :pointer, :int], :pointer
    attach_function :Tcl_ParseVar, [:pointer, :pointer, :pointer], :pointer
    attach_function :Tcl_SetObjResult, [:pointer, :pointer], :void
    attach_function :Tcl_WaitForEvent, [:pointer], :int
    attach_function :Tcl_SetMaxBlockTime, [:pointer], :void
    attach_function :Tcl_DictObjGet, [:pointer, :pointer, :pointer, :pointer], :int
    attach_function :Tcl_DictObjPut, [:pointer, :pointer, :pointer, :pointer], :int
    attach_function :Tcl_DictObjRemove, [:pointer, :pointer, :pointer], :int
    attach_function :Tcl_DictObjSize, [:pointer, :pointer, :pointer], :int
    attach_function :Tcl_DictObjFirst, [:pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :int
    attach_function :Tcl_DictObjNext, [:pointer, :pointer, :pointer, :pointer], :void
    attach_function :Tcl_DictObjDone, [:pointer], :void
    attach_function :Tcl_DictObjPutKeyList, [:pointer, :pointer, :int, :pointer, :pointer], :int
    attach_function :Tcl_DictObjRemoveKeyList, [:pointer, :pointer, :int, :pointer], :int

    callback :obj_cmd_proc, [:int, :pointer, :int, :pointer], :int
    callback :obj_delete_proc, [:int], :void
    attach_function :Tcl_CreateObjCommand, [
      :pointer, :string, :obj_cmd_proc, :int, :obj_delete_proc], :pointer

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
