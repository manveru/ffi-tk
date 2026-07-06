# frozen_string_literal: true

module FFI
  module Tcl
    # FFI wrapper around a Tcl interpreter (Tcl_Interp).
    # Evaluates scripts and marshals results between Tcl and Ruby.
    class Interp < PrettyStruct
      layout(
        :result, :string,
        :freeProc, :pointer,
        :errorLine, :int
      )

      EVAL_GLOBAL = 0x20000
      EVAL_DIRECT = 0x40000

      def inspect
        'Interp'
      end

      def guess_result
        EvalResult.guess(self, Obj.new(Tcl.get_obj_result(self)))
      end

      def obj_result
        Obj.new(Tcl.get_obj_result(self))
      end

      def obj_result=(ruby_obj)
        Tcl.set_obj_result(self, ruby_to_tcl_obj(ruby_obj))
      end

      # Convert a Ruby value into a freshly allocated Tcl_Obj pointer.
      # Tcl_SetObjResult takes ownership of the returned obj, so every branch
      # must yield a real Tcl_Obj — passing a Ruby String here would make Tcl
      # dereference the string bytes as a struct and crash later in
      # Tcl_GetStringFromObj.
      def ruby_to_tcl_obj(ruby_obj)
        case ruby_obj
        when nil
          Tcl.new_string_obj('', 0)
        when true
          Tcl.new_boolean_obj(1)
        when false
          Tcl.new_boolean_obj(0)
        when ::String
          Tcl.new_string_obj(ruby_obj, ruby_obj.bytesize)
        when ::Symbol
          string = ruby_obj.to_s
          Tcl.new_string_obj(string, string.bytesize)
        when ::Integer
          Tcl.new_wide_int_obj(ruby_obj)
        when ::Float
          Tcl.new_double_obj(ruby_obj)
        when ::Array
          elements = ruby_obj.map { |element| ruby_to_tcl_obj(element) }
          pointer = ::FFI::MemoryPointer.new(:pointer, elements.size)
          pointer.write_array_of_pointer(elements)
          Tcl.new_list_obj(elements.size, pointer)
        when Exception
          string = [ruby_obj.message, *ruby_obj.backtrace].join("\n")
          Tcl.new_string_obj(string, string.bytesize)
        else
          unless ruby_obj.respond_to?(:to_tcl)
            raise ArgumentError, format("Don't know how to set %p automatically", ruby_obj)
          end

          string = ruby_obj.to_tcl.to_s
          Tcl.new_string_obj(string, string.bytesize)
        end
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
        loop do
          wait_for_event(0.1)
          Tcl.do_one_event(flag)
          break if yield
        end
      end

      def do_events_while(flag = 0)
        loop do
          wait_for_event(0.1)
          Tcl.do_one_event(flag)
          break unless yield
        end
      end

      def eval(string)
        if $DEBUG
          if string =~ /\n/
            puts format("\neval: %p", string)
          else
            puts format("\neval: %s", string)
          end
        end

        code = Tcl.eval_ex(self, string, string.bytesize, EVAL_DIRECT)
        puts format('eval= %p', code) if $DEBUG
        return true if code.zero?

        message = guess_result.to_s
        puts format('eval= %p', message) if $DEBUG

        raise format('Failure during eval of: %p', string) if message.empty?

        raise format('%s during eval of: %p', message, string)
      end
    end
  end
end
