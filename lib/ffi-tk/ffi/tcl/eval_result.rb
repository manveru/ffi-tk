# frozen_string_literal: true
module FFI
  module Tcl
    # This whole class feels very awkward, maybe it should be merged with Obj.
    class EvalResult < ::Struct.new(:interp, :obj)
      TYPES = {}

      def self.reset_types(interp)
        TYPES.clear
        list = Tcl.new_list_obj(0, nil)
        Tcl.append_all_obj_types(interp, list)

        objc_ptr = MemoryPointer.new(:int)
        objv_ptr = MemoryPointer.new(:pointer)

        string_length_ptr = MemoryPointer.new(:int)

        if Tcl.list_obj_get_elements(interp, list, objc_ptr, objv_ptr) == 0
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
        # p obj: obj, obj_type: obj.type
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
        when :dict
          to_dict(interp, obj)
        when :window
          to_window(interp, obj)
        else
          if fallback
            __send__(fallback, interp, obj)
          elsif type.nil? && obj.bytes == ''
            nil
          elsif type.nil?
            to_string(interp, obj)
          else
            raise 'Unknown type: %p' % [type]
          end
        end
      end

      def self.to_window(interp, obj)
        p interp: interp, obj: obj
      end

      def self.to_dict(interp, obj)
        out = {}

        search = MemoryPointer.new(:pointer)
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

      def self.map_list_core(interp, obj, &block)
        objc_ptr = MemoryPointer.new(:int)
        objv_ptr = MemoryPointer.new(:pointer)

        if Tcl.list_obj_get_elements(interp, obj, objc_ptr, objv_ptr) == 0
          return [] if objv_ptr.get_pointer(0).null?
          objv_ptr.get_pointer(0)
                  .read_array_of_pointer(objc_ptr.get_int(0))
                  .map(&block)
        else
          panic(interp, 'Tcl_ListObjGetElements')
        end
      end

      def self.to_boolean(interp, obj)
        boolean_pointer = MemoryPointer.new(:int)

        if Tcl.get_boolean_from_obj(interp, obj, boolean_pointer) == 0
          boolean_pointer.get_int(0) == 1
        else
          panic(interp, 'Tcl_GetBooleanFromObj')
        end
      end

      def self.to_int(interp, obj)
        int_pointer = MemoryPointer.new(:int)

        if obj.bytes == ''
          '' # used by text widget -endline
        elsif Tcl.get_int_from_obj(interp, obj, int_pointer) == 0
          int_pointer.get_int(0)
        else
          panic(interp, 'Tcl_GetIntFromObj')
        end
      end

      def self.to_string(_interp, obj)
        length_pointer = MemoryPointer.new(:int)

        string = Tcl.get_string_from_obj(obj, length_pointer)
        string.force_encoding(Encoding.default_external)
      end

      def self.panic(interp, function)
        message = guess(interp, Obj.new(Tcl.get_obj_result(interp))).to_s

        if message.empty?
          raise 'Failure during call of: %p' % [function]
        else
          raise '%s during call of: %p' % [message, function]
        end
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
