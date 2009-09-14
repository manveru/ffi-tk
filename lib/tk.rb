require 'ffi'

module FFI
  module Tk
    extend FFI::Library

    ffi_lib 'libtk8.5'

    callback :init, [:pointer], :int
    attach_function :Tk_MainEx, [:int, :pointer, :init, :pointer], :void
    attach_function :Tk_Init, [:pointer], :int
    attach_function :Tk_SafeInit, [:pointer], :int
    attach_function :Tk_MainLoop, [], :void

    module_function

    def Tk_Main(argc, argv, proc)
      interp = Tcl::Tcl_CreateInterp()
      Tk_MainEx(argc, argv, proc.to_proc, interp)
    end
  end
end
