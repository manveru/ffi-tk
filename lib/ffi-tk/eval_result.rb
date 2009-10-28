module Tk
  EvalResult = Struct.new(:obj)
  class EvalResult
    def to_index
      self
    end

    def to_boolean
      boolean_pointer = FFI::MemoryPointer.new(:int)
      FFI::Tcl.get_boolean_from_obj(Tk.interp, obj, boolean_pointer)
      boolean = boolean_pointer.get_int(0)
      boolean == 1
    end

    def to_integer
      int_pointer = FFI::MemoryPointer.new(:int)
      FFI::Tcl.get_int_from_obj(Tk.interp, obj, int_pointer)
      int_pointer.get_int(0)
    end

    def to_string
      length_pointer = FFI::MemoryPointer.new(:int)
      FFI::Tcl.get_string_from_obj(obj, length_pointer)
    end

    def to_symbol
      to_string.to_sym
    end

    def to_color
      self
    end

    def to_font
      self
    end

    # FIXME:
    #   this might fail big time because we cannot use macros through FFI to
    #   increase/decrease the ref count of the objects we operate on, let's pray
    #   and hope it works this way because the GC should be blocked by Ruby
    #   anyway.
    def to_list
      length_pointer = FFI::MemoryPointer.new(:int)
      result_pointer = FFI::MemoryPointer.new(:pointer)
      count_pointer = FFI::MemoryPointer.new(:int)

      FFI::Tcl.list_obj_length(Tk.interp, obj, count_pointer)
      count = count_pointer.get_int(0)

      (0...count).map do |idx|
        FFI::Tcl.list_obj_index(Tk.interp, obj, idx, result_pointer)
        obj = result_pointer.get_pointer(0)
        FFI::Tcl.get_string_from_obj(obj, length_pointer)
      end
    end
  end
end