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

      # Raw string of the current result object, straight from
      # Tcl_GetStringFromObj (never EvalResult.guess), so the option path reads
      # values immune to Tcl shimmering.
      def result_string
        EvalResult.to_string(self, obj_result)
      end

      def obj_result=(ruby_obj)
        Tcl.set_obj_result(self, ruby_to_tcl_obj(ruby_obj))
      end

      # Set the result from a callback's return value. Tk ignores the result of
      # an ordinary -command/bind script, so a value with no Tcl representation
      # (an arbitrary object returned as the block's tail expression) is
      # best-effort: dropped to an empty result rather than raised as a spurious
      # Tcl error. Convertible values still round-trip for the callbacks
      # (validation, scrollbar) that legitimately return a result.
      def callback_result=(ruby_obj)
        self.obj_result = tcl_convertible?(ruby_obj) ? ruby_obj : nil
      end

      # Whether ruby_to_tcl_obj can build a Tcl_Obj for this value. The type
      # list mirrors the dispatch in ruby_to_tcl_obj and must stay in sync with
      # it; anything else (an arbitrary object with no #to_tcl) has no Tcl
      # representation. Lets callers with a discardable value (a callback whose
      # return is coincidental) skip it rather than force a conversion error.
      def tcl_convertible?(ruby_obj)
        case ruby_obj
        when nil, true, false, ::String, ::Symbol, ::Integer, ::Float, ::Array, Exception
          true
        else
          ruby_obj.respond_to?(:to_tcl)
        end
      end

      # Convert a Ruby value into a freshly allocated Tcl_Obj pointer.
      # Tcl_SetObjResult takes ownership of the returned obj, so every branch
      # must yield a real Tcl_Obj — passing a Ruby String here would make Tcl
      # dereference the string bytes as a struct and crash later in
      # Tcl_GetStringFromObj.
      def ruby_to_tcl_obj(ruby_obj)
        case ruby_obj
        when nil then Tcl.new_string_obj('', 0)
        when true then Tcl.new_boolean_obj(1)
        when false then Tcl.new_boolean_obj(0)
        when ::String then new_string_obj(ruby_obj)
        when ::Symbol then new_string_obj(ruby_obj.to_s)
        when ::Integer then Tcl.new_wide_int_obj(ruby_obj)
        when ::Float then Tcl.new_double_obj(ruby_obj)
        when ::Array then new_list_obj(ruby_obj)
        when Exception then new_string_obj([ruby_obj.message, *ruby_obj.backtrace].join("\n"))
        else
          unless ruby_obj.respond_to?(:to_tcl)
            raise ArgumentError, format("Don't know how to set %p automatically", ruby_obj)
          end

          new_string_obj(ruby_obj.to_tcl.to_s)
        end
      end

      def new_string_obj(string)
        Tcl.new_string_obj(string, string.bytesize)
      end

      def new_list_obj(array)
        elements = array.map { |element| ruby_to_tcl_obj(element) }
        pointer = ::FFI::MemoryPointer.new(:pointer, elements.size)
        pointer.write_array_of_pointer(elements)
        Tcl.new_list_obj(elements.size, pointer)
      end

      def wait_for_event(seconds = 0.0)
        Tcl.wait_for_event(tcl_time(seconds))
      end

      # Split a duration in seconds into a Tcl_Time (whole seconds + the
      # remainder in microseconds). Returns nil for a non-positive duration,
      # which tells Tcl_WaitForEvent to block/poll rather than time out.
      def tcl_time(seconds)
        return nil unless seconds && seconds > 0.0

        whole = seconds.to_i
        TclTime.new(whole, ((seconds - whole) * 1_000_000).round)
      end

      def do_one_event(flag = 0)
        Tcl.do_one_event(flag)
      end

      # Drain every pending event without blocking, then wait up to 100ms for
      # new OS events, until the condition holds. Never blocks indefinitely,
      # so condition-polling callers (the specs) survive an idle display.
      def do_events_until(flag = 0)
        until yield
          nil while Tcl.do_one_event(flag | ::Tk::DONT_WAIT) == 1
          wait_for_event(0.1)
        end
      end

      def do_events_while(flag = 0)
        do_events_until(flag) { !yield }
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
