module FFI
  module Tk
    extend FFI::Library
    ffi_lib 'libtk8.5.so', 'libtk.so', 'Tk', 'libtk'

    attach_function :Tk_Init, [:pointer], :int
    attach_function :Tk_MainLoop, [], :void

    module_function

    def mainloop
      Tcl.thread_send{ Tk_MainLoop() }
    end

    def init(interp)
      Tcl.thread_send do
        if Tk_Init(interp) == 1
          message = Tcl.Tcl_GetStringResult(interp)
          raise RuntimeError, message
        end
      end
    end
  end
end
