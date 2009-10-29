module FFI
  module Tk
    extend FFI::Library
    ffi_lib 'libtk8.5.so', 'libtk.so', 'Tk', 'libtk'

    attach_function :Tk_Init, [:pointer], :int

    module_function

    def init(interp)
      if Tk_Init(interp) == 1
        message = FFI::Tcl.Tcl_GetStringResult(interp)
        raise RuntimeError, message
      end
    end
  end
end