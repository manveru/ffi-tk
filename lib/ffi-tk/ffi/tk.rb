module FFI
  module Tk
    extend FFI::Library
    ffi_lib 'libtk8.5.so', 'libtk.so', *::Tk::LIBPATH[:tk]

    attach_function :Tk_Init, [:pointer], :int
    attach_function :Tk_MainLoop, [], :void

    module_function

    def mainloop
      if ::Tk::RUN_EVENTLOOP_ON_MAIN_THREAD
        Tk_MainLoop()
      else
        Tcl.thread_sender.thread_send{ Tk_MainLoop() }
      end
    end

    def init(interp)
      if ::Tk::RUN_EVENTLOOP_ON_MAIN_THREAD
        if Tk_Init(interp) == 1
          message = Tcl.Tcl_GetStringResult(interp)
          raise RuntimeError, message
        end
      else
        Tcl.thread_sender.thread_send do
          if Tk_Init(interp) == 1
            message = Tcl.Tcl_GetStringResult(interp)
            raise RuntimeError, message
          end
        end
      end
    end
  end
end
