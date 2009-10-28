module Tk
  class EvalResult < Struct.new(:obj)
    TYPES = {}

    list = FFI::Tcl.new_list_obj(0, nil)
    FFI::Tcl.append_all_obj_types(Tk.interp, list)
    types_names = FFI::Tcl.list_map_string(Tk.interp, list)

    types_names.each do |name|
      type = FFI::Tcl.get_obj_type(name)
      TYPES[type.to_i] = name.to_sym
    end

    def self.guess(obj)
      case type = TYPES[obj.type.to_i]
      when :list
        to_list(obj)
      when :string, :pixel
        to_string(obj)
      when :int
        to_int(obj)
      else
        raise "Unknown type: %p" % [type] if type
        new(obj)
      end
    end

    def self.to_list(obj)
      interp = Tk.interp
      result_pointer = FFI::MemoryPointer.new(:pointer)
      count_pointer  = FFI::MemoryPointer.new(:int)
      length_pointer = FFI::MemoryPointer.new(:int)

      FFI::Tcl.list_obj_length(interp, obj, count_pointer)
      count = count_pointer.get_int(0)

      (0...count).map do |idx|
        FFI::Tcl.list_obj_index(interp, obj, idx, result_pointer)
        element_pointer = result_pointer.get_pointer(0)
        value = FFI::Tcl.get_string_from_obj(element_pointer, length_pointer)
        block_given? ? yield(value) : value
      end
    end

    def self.to_boolean(obj)
      boolean_pointer = FFI::MemoryPointer.new(:int)
      FFI::Tcl.get_boolean_from_obj(Tk.interp, obj, boolean_pointer)
      boolean_pointer.get_int(0) == 1
    end

    def self.to_int(obj)
      int_pointer = FFI::MemoryPointer.new(:int)
      FFI::Tcl.get_int_from_obj(Tk.interp, obj, int_pointer)
      int_pointer.get_int(0)
    end

    def self.to_string(obj)
      length_pointer = FFI::MemoryPointer.new(:int)
      FFI::Tcl.get_string_from_obj(obj, length_pointer)
    end

    def to_a
      self.class.to_list(obj)
    end

    def to_sym
      string = self.class.to_string(obj)
      string.empty? ? nil : string.to_sym
    end

    def to_i
      self.class.to_int(obj)
    end

    def to_s
      self.class.to_string(obj)
    end

    def to_bool
      self.class.to_boolean(obj)
    end
  end
end