# frozen_string_literal: true

module FFI
  module Tcl
    # This whole class feels very awkward, maybe it should be merged with Obj.
    EvalResult = ::Struct.new(:interp, :obj) do
      # Per-interpreter type cache: cleared and repopulated at runtime by
      # reset_types, so it is intentionally mutable.
      TYPES = {} # rubocop:disable Style/MutableConstant

      def self.reset_types(interp)
        TYPES.clear
        list = Tcl.new_list_obj(0, nil)
        Tcl.append_all_obj_types(interp, list)

        objc_ptr = MemoryPointer.new(:int)
        objv_ptr = MemoryPointer.new(:pointer)

        string_length_ptr = MemoryPointer.new(:int)

        if Tcl.list_obj_get_elements(interp, list, objc_ptr, objv_ptr).zero?
          return [] if objv_ptr.get_pointer(0).null?

          array_ptr = objv_ptr.get_pointer(0)
          array_length = objc_ptr.get_int(0)
          array = array_ptr.read_array_of_pointer(array_length)
          array.each do |type_ptr|
            name = Tcl.get_string_from_obj(type_ptr, string_length_ptr)
            type = Tcl.get_obj_type(name)
            TYPES[type.to_i] = name.to_sym
          end
        else
          panic 'Tcl_ListObjGetElements'
        end
      end

      def self.guess(interp, obj, fallback = nil)
        obj = Obj.new(obj) unless obj.respond_to?(:type)
        type = TYPES[obj.type.to_i]

        case type
        when :list then to_list(interp, obj)
        when :string, :pixel, :cmdName then to_string(interp, obj)
        when :int then to_int(interp, obj)
        when :double then to_double(interp, obj)
        when :bytearray then to_bytearray(interp, obj)
        when :dict then to_dict(interp, obj)
        when :window then to_window(interp, obj)
        else guess_fallback(interp, obj, type, fallback)
        end
      end

      def self.guess_fallback(interp, obj, type, fallback)
        if fallback
          __send__(fallback, interp, obj)
        elsif type.nil? && obj.bytes == ''
          nil
        elsif type.nil?
          to_string(interp, obj)
        else
          raise format('Unknown type: %p', type)
        end
      end

      # A :window-typed Tcl_Obj's string representation is its path name, so
      # resolve it the same way as any string result.
      def self.to_window(interp, obj)
        to_string(interp, obj)
      end

      def self.to_dict(interp, obj)
        out = {}

        search = TclDictSearch.new
        done = MemoryPointer.new(:int)
        key_ptr = MemoryPointer.new(:pointer)
        value_ptr = MemoryPointer.new(:pointer)
        strlen = MemoryPointer.new(:int)

        Tcl.dict_obj_first(interp, obj, search, key_ptr, value_ptr, done)

        while done.get_int(0) != 1
          key = Tcl.get_string_from_obj(key_ptr.get_pointer(0), strlen)
          value = Tcl.get_string_from_obj(value_ptr.get_pointer(0), strlen)
          out[key] = value

          Tcl.dict_obj_next(search, key_ptr, value_ptr, done)
        end

        out
      end

      def self.to_double(interp, obj)
        double_pointer = MemoryPointer.new(:double)

        unless Tcl.get_double_from_obj(interp, obj, double_pointer).zero?
          raise format("Couldn't get double from %p", obj)
        end

        double_pointer.get_double(0)
      end

      def self.to_list(interp, obj)
        map_list_core(interp, obj) do |pointer|
          value = guess(interp, pointer, :to_string)
          block_given? ? yield(value) : value
        end
      end

      def self.map_list_core(interp, obj, &)
        objc_ptr = MemoryPointer.new(:int)
        objv_ptr = MemoryPointer.new(:pointer)

        if Tcl.list_obj_get_elements(interp, obj, objc_ptr, objv_ptr).zero?
          return [] if objv_ptr.get_pointer(0).null?

          objv_ptr.get_pointer(0)
                  .read_array_of_pointer(objc_ptr.get_int(0))
                  .map(&)
        else
          panic(interp, 'Tcl_ListObjGetElements')
        end
      end

      def self.to_boolean(interp, obj)
        boolean_pointer = MemoryPointer.new(:int)

        if Tcl.get_boolean_from_obj(interp, obj, boolean_pointer).zero?
          boolean_pointer.get_int(0) == 1
        else
          panic(interp, 'Tcl_GetBooleanFromObj')
        end
      end

      def self.to_int(interp, obj)
        # Convert through Tcl's wide (64-bit) int so integer-typed values above
        # the 32-bit boundary neither wrap nor overflow (Tcl_GetIntFromObj reads
        # a C 32-bit int and does both).
        wide_pointer = MemoryPointer.new(:int64)

        if obj.bytes == ''
          '' # used by text widget -endline
        elsif Tcl.get_wide_int_from_obj(interp, obj, wide_pointer).zero?
          wide_pointer.get_int64(0)
        else
          panic(interp, 'Tcl_GetWideIntFromObj')
        end
      end

      # Tcl bytearray objects hold arbitrary binary data (e.g. `binary format`).
      # Read the raw bytes directly; get_string_from_obj would mangle them,
      # re-encoding NUL and high bytes as Tcl's modified UTF-8.
      def self.to_bytearray(_interp, obj)
        length_pointer = MemoryPointer.new(:int)
        byte_pointer = Tcl.get_byte_array_from_obj(obj, length_pointer)
        byte_pointer.read_bytes(length_pointer.get_int(0))
      end

      def self.to_string(_interp, obj)
        length_pointer = MemoryPointer.new(:int)

        string = Tcl.get_string_from_obj(obj, length_pointer)
        string.force_encoding(Encoding.default_external)
      end

      def self.panic(interp, function)
        message = guess(interp, Obj.new(Tcl.get_obj_result(interp))).to_s

        raise format('Failure during call of: %p', function) if message.empty?

        raise format('%s during call of: %p', message, function)
      end

      def to_a(&)
        self.class.to_list(interp, obj, &)
      end

      def to_a?(&)
        value = self.class.to_list(interp, obj, &)
        value.empty? ? nil : value
      end

      def to_sym
        self.class.to_string(interp, obj).to_sym
      end

      def to_sym?
        value = self.class.to_string(interp, obj)
        value.empty? ? nil : value.to_sym
      end

      def to_i
        self.class.to_int(interp, obj)
      end

      def to_f
        self.class.to_double(interp, obj)
      end

      def to_s
        self.class.to_string(interp, obj)
      end

      def to_s?
        value = self.class.to_string(interp, obj)
        value.empty? ? nil : value
      end

      def to_boolean
        self.class.to_boolean(interp, obj)
      end

      def to_tcl
        to_s.to_tcl
      end

      def inspect
        "#<EvalResult #{self}>"
      end
    end
  end
end
