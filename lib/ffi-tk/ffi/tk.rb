module FFI
  module Tk
    extend FFI::Library
    ffi_lib ::Tk::TK_LIBPATH

    class XColor < FFI::Struct
      layout(
        :pixel, :ulong,
        :red,   :ushort,
        :green, :ushort,
        :blue,  :ushort,
        :flags, :char,
        :pad,   :char
      )

      def red
        self[:red]
      end

      def green
        self[:green]
      end

      def blue
        self[:blue]
      end
    end

    # This is opaque
    class Window < FFI::Struct
    end

    attach_function :Tk_Init, [:pointer], :int
    attach_function :Tk_MainWindow, [:pointer], :pointer
    attach_function :Tk_GetColor, [:pointer, :pointer, name = :string], :pointer
    attach_function :Tk_MainLoop, [], :void

    module_function

    def get_color(interp, string)
      if ::Tk::RUN_EVENTLOOP_ON_MAIN_THREAD
        XColor.new(Tk_GetColor(interp, Tk_MainWindow(interp), string))
      else
        Tcl.thread_sender.thread_send{
          XColor.new(Tk_GetColor(interp, Tk_MainWindow(interp), string))
        }
      end
    end

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
