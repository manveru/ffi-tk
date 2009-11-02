module FFI
  module Tcl
    # This whole class feels very awkward, maybe it should be merged with Obj.
    class EvalResult < ::Struct.new(:interp, :obj)
      TYPES = {}

      def self.reset_types(interp)
        TYPES.clear
        list = Tcl.new_list_obj(0, nil)
        Tcl.append_all_obj_types(interp, list)
        types_names = Tcl.list_map_string(interp, list)

        types_names.each do |name|
          type = Tcl.get_obj_type(name)
          TYPES[type.to_i] = name.to_sym
        end
      end

      def self.guess(interp, obj, fallback = nil)
        obj = Obj.new(obj) unless obj.respond_to?(:type)
        type = TYPES[obj.type.to_i]

        case type
        when :list
          to_list(interp, obj)
        when :string, :pixel, :cmdName
          to_string(interp, obj)
        when :int
          to_int(interp, obj)
        when :double
          to_double(interp, obj)
        else
          if fallback
            __send__(fallback, interp, obj)
          else
            raise "Unknown type: %p" % [type] if type
            new(interp, obj)
          end
        end
      end

      def self.to_double(interp, obj)
        double_pointer = MemoryPointer.new(:double)

        if Tcl.get_double_from_obj(interp, obj, double_pointer) == 0
          double_pointer.get_double(0)
        else
          raise "Couldn't get double from %p" % [obj]
        end
      end

      def self.to_list(interp, obj)
        map_list_core(interp, obj) do |pointer|
          value = guess(interp, pointer, :to_string)
          block_given? ? yield(value) : value
        end
      end

      def self.map_list_core(interp, obj)
        result_pointer = MemoryPointer.new(:pointer)
        count_pointer  = MemoryPointer.new(:int)
        length_pointer = MemoryPointer.new(:int)

        Tcl.list_obj_length(interp, obj, count_pointer)
        count = count_pointer.get_int(0)

        (0...count).map do |idx|
          Tcl.list_obj_index(interp, obj, idx, result_pointer)
          element_pointer = result_pointer.get_pointer(0)
          yield element_pointer
        end
      end

      def self.to_boolean(interp, obj)
        boolean_pointer = MemoryPointer.new(:int)
        Tcl.get_boolean_from_obj(interp, obj, boolean_pointer)
        boolean_pointer.get_int(0) == 1
      end

      def self.to_int(interp, obj)
        int_pointer = MemoryPointer.new(:int)
        Tcl.get_int_from_obj(interp, obj, int_pointer)
        int_pointer.get_int(0)
      end

      def self.to_string(interp, obj)
        length_pointer = MemoryPointer.new(:int)
        string = Tcl.get_string_from_obj(obj, length_pointer)
        string.force_encoding(Encoding.default_external)
      end

      def to_a(&block)
        self.class.to_list(interp, obj, &block)
      end

      def to_a?(&block)
        value = self.class.to_list(interp, obj, &block)
        value.empty? ? nil : value
      end

      def to_sym
        self.class.to_string(interp, obj).to_sym
      end

      def to_sym?
        value = self.class.to_string(interp, obj).to_sym
        value.empty? ? nil : value.to_sym
      end

      def to_i
        self.class.to_int(interp, obj)
      end

      def to_s
        self.class.to_string(interp, obj)
      end

      def to_s?
        value = self.class.to_string(interp, obj)
        value.empty? ? nil : value
      end

      def to_bool
        self.class.to_boolean(interp, obj)
      end
    end
  end
end