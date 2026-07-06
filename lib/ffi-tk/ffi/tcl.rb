# frozen_string_literal: true

require 'ffi-tk/ffi/tcl/obj'
require 'ffi-tk/ffi/tcl/interp'
require 'ffi-tk/ffi/tcl/cmd_proc'
require 'ffi-tk/ffi/tcl/time'
require 'ffi-tk/ffi/tcl/eval_result'

module FFI
  # Low-level FFI bindings to the Tcl C library (libtcl).
  module Tcl
    extend FFI::Library

    ffi_lib ::Tk::TCL_LIBPATH

    attach_function :Tcl_AppendAllObjTypes, %i[pointer pointer], :int
    attach_function :Tcl_CreateInterp, [], :pointer
    attach_function :Tcl_DeleteInterp, [:pointer], :void
    attach_function :Tcl_DoOneEvent, [:int], :int
    attach_function :Tcl_EvalEx, %i[pointer string int int], :int
    attach_function :Tcl_GetBoolean, %i[pointer string pointer], :int
    attach_function :Tcl_GetBooleanFromObj, %i[pointer pointer pointer], :int
    attach_function :Tcl_GetDoubleFromObj, %i[pointer pointer pointer], :int
    attach_function :Tcl_GetIntFromObj, %i[pointer pointer pointer], :int
    attach_function :Tcl_GetWideIntFromObj, %i[pointer pointer pointer], :int
    attach_function :Tcl_GetByteArrayFromObj, %i[pointer pointer], :pointer
    attach_function :Tcl_GetObjResult, [:pointer], :pointer
    attach_function :Tcl_GetObjType, [:string], :pointer
    attach_function :Tcl_GetString, [:pointer], :string
    attach_function :Tcl_GetStringFromObj, %i[pointer pointer], :string
    attach_function :Tcl_GetStringResult, [:pointer], :string
    attach_function :Tcl_GetUnicode, [:pointer], :string
    attach_function :Tcl_Init, [:pointer], :int
    attach_function :Tcl_ListObjGetElements, %i[pointer pointer pointer pointer], :int
    attach_function :Tcl_ListObjIndex, %i[pointer pointer int pointer], :int
    attach_function :Tcl_ListObjLength, %i[pointer pointer pointer], :int
    attach_function :Tcl_NewBooleanObj, [:int], :pointer
    attach_function :Tcl_NewDoubleObj, [:double], :pointer
    attach_function :Tcl_NewIntObj, [:int], :pointer
    attach_function :Tcl_NewListObj, %i[int pointer], :pointer
    attach_function :Tcl_NewStringObj, %i[string int], :pointer
    attach_function :Tcl_NewWideIntObj, [:int64], :pointer
    attach_function :Tcl_NewDictObj, [], :pointer
    attach_function :Tcl_ObjGetVar2, %i[pointer pointer pointer int], :pointer
    attach_function :Tcl_ObjSetVar2, %i[pointer pointer pointer pointer int], :pointer
    attach_function :Tcl_ParseVar, %i[pointer pointer pointer], :pointer
    attach_function :Tcl_SetObjResult, %i[pointer pointer], :void
    attach_function :Tcl_WaitForEvent, [:pointer], :int
    attach_function :Tcl_SetMaxBlockTime, [:pointer], :void
    attach_function :Tcl_DictObjGet, %i[pointer pointer pointer pointer], :int
    attach_function :Tcl_DictObjPut, %i[pointer pointer pointer pointer], :int
    attach_function :Tcl_DictObjRemove, %i[pointer pointer pointer], :int
    attach_function :Tcl_DictObjSize, %i[pointer pointer pointer], :int
    attach_function :Tcl_DictObjFirst, %i[pointer pointer pointer pointer pointer pointer], :int
    attach_function :Tcl_DictObjNext, %i[pointer pointer pointer pointer], :void
    attach_function :Tcl_DictObjDone, [:pointer], :void
    attach_function :Tcl_DictObjPutKeyList, %i[pointer pointer int pointer pointer], :int
    attach_function :Tcl_DictObjRemoveKeyList, %i[pointer pointer int pointer], :int

    callback :obj_cmd_proc, %i[int pointer int pointer], :int
    callback :obj_delete_proc, [:int], :void
    attach_function :Tcl_CreateObjCommand, %i[
      pointer string obj_cmd_proc int obj_delete_proc
    ], :pointer

    module_function

    ATTACHED_FUNCTIONS = singleton_methods.grep(/^Tcl_/).each_with_object({}) do |function, functions|
      ruby_name = function.to_s
                          .gsub(/([A-Z][a-z]+)/, '_\1').sub('_Tcl__', '').downcase
      functions[function] = ruby_name
    end.freeze
    BINDING = binding

    def setup_eventloop_on_new_thread
      puts 'Run eventloop on new thread' if $DEBUG

      code = <<~RUBY.strip
        def self.%s(*args, &block)
          @thread_sender.thread_send{ %s(*args, &block) }
        end
      RUBY

      binding = BINDING
      file = __FILE__
      line = __LINE__ - 5
      ATTACHED_FUNCTIONS.each do |function, ruby_name|
        eval(format(code, ruby_name, function), binding, file, line) # rubocop:disable Security/Eval
      end

      @thread_sender = ThreadSender.new
      class << self; attr_reader :thread_sender; end
      @thread_sender.thread_send { Interp.new(create_interp) }
    end

    def setup_eventloop_on_main_thread
      puts 'Run eventloop on main thread' if $DEBUG

      code = <<~RUBY.strip
        def self.%s(*args, &block)
          %s(*args, &block)
        end
      RUBY

      binding = BINDING
      file = __FILE__
      line = __LINE__ - 5
      ATTACHED_FUNCTIONS.each do |function, ruby_name|
        eval(format(code, ruby_name, function), binding, file, line) # rubocop:disable Security/Eval
      end

      Interp.new(create_interp)
    end
  end
end
