module FFI
  module Tcl
    class Interp < PrettyStruct
      layout(
        :result, :string,
        :freeProc, :pointer,
        :errorLine, :int
      )

      def self.create
        new(Tcl.create_interp)
      end

      def guess_result
        EvalResult.guess(self, Obj.new(Tcl.get_obj_result(self)))
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

      def do_events_until
        wait_for_event(0.1)
        do_one_event until yield
      end

      def eval(string)
        p eval_ex: string if $DEBUG

        code = Tcl.eval_ex(self, string, string.bytesize, 0x40000)
        return true if code == 0

        message = guess_result.to_s

        if message.empty?
          raise 'Failure during eval of: %p' % [string]
        else
          raise '%s during eval of: %p' % [message, string]
        end
      end
    end
  end
end