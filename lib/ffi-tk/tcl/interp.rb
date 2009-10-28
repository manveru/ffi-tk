module FFI
  module Tcl
    class Interp < FFI::Struct
      layout(
        :result, :string,
        :freeProc, :pointer,
        :errorLine, :int
      )

      def self.create
        new(Tcl.create_interp)
      end

      def string_result
        Tcl.get_string_result(self)
      end

      def obj_result
        Obj.new(Tcl.get_obj_result(self))
      end

      def wait_for_event(seconds = 0.0)
        if seconds && seconds > 0.0
          seconds, microseconds = (seconds * 1000).divmod(1000)
          time = TclTime.new(seconds, microseconds)
        else
          time = nil
        end

        Tcl.wait_for_event(time)
      end

      def do_one_event(flag = 0)
        Tcl.do_one_event(flag)
      end

      def eval(string)
        p eval_ex: string unless string == '_get_ev'
        # result = FFI::Tcl.eval_ex(self, string, string.bytesize, 0x40000)
        result = FFI::Tcl.eval(self, string)

        if result == 1
          message = string_result
          raise message
        end
      end
    end
  end
end