module FFI
  module Tcl
    class Interp < PrettyStruct
      layout(
        :result, :string,
        :freeProc, :pointer,
        :errorLine, :int
      )

      EVAL_GLOBAL = 0x20000
      EVAL_DIRECT = 0x40000

      def inspect
        "Interp"
      end

      def guess_result
        EvalResult.guess(self, Obj.new(Tcl.get_obj_result(self)))
      end

      def obj_result
        Obj.new(Tcl.get_obj_result(self))
      end

      def obj_result=(ruby_obj)
        obj =
          case ruby_obj
          when true
            Tcl.new_boolean_obj(1)
          when false
            Tcl.new_boolean_obj(0)
          when String
            Tcl.new_string_obj(ruby_obj, ruby_obj.bytesize)
          when Fixnum
            Tcl.new_int_obj(ruby_obj)
          when Exception
            string = [ruby_obj.message, *ruby_obj.backtrace].join("\n")
            Tcl.new_string_obj(string, string.bytesize)
          else
            if ruby_obj.respond_to?(:to_tcl)
              ruby_obj.to_tcl
            else
              raise ArgumentError, "Don't know how to set %p automatically" % [ruby_obj]
            end
          end

        Tcl.set_obj_result(self, obj)
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

      def do_events_until(flag = 0)
        begin
          wait_for_event(0.1)
          Tcl.do_one_event(flag)
        end until yield
      end

      def do_events_while(flag = 0)
        begin
          wait_for_event(0.1)
          Tcl.do_one_event(flag)
        end while yield
      end

      def eval(string)
        if $DEBUG
          if string =~ /\n/
            puts "eval: %p" % [string]
          else
            puts "eval: %s" % [string]
          end
        end

        code = Tcl.eval_ex(self, string, string.bytesize, EVAL_DIRECT)
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
