module FFI
  module Tcl
    # Nicer introspection and some accessors.
    class PrettyStruct < FFI::Struct
      ACCESSOR_CODE = <<-CODE
        def {name}; self[{sym}]; end
        def {name}=(value) self[{sym}] = value; end
      CODE

      def self.layout(*kvs)
        kvs.each_slice(2) do |key, value|
          eval ACCESSOR_CODE.gsub(/\{(.*?)\}/, '{name}' => key, '{sym}' => ":#{key}")
        end

        super
      end

      def inspect
        kvs = members.zip(values)
        kvs.map!{|key, value| "%s=%s" % [key, value.inspect] }
        "<%s %s>" % [self.class, kvs.join(' ')]
      end
    end

    # The following structure represents a type of object, which is a particular
    # internal representation for an object plus a set of functions that provide
    # standard operations on objects of that type.
    class ObjType < PrettyStruct
      layout(
        :name,                   :string,
        :free_internal_rep_proc, :pointer,
        :dup_internal_rep_proc,  :pointer,
        :update_string_proc,     :pointer,
        :set_from_any_proc,      :pointer
      )

      def to_i
        pointer.get_pointer(0).to_i
      end
    end

    class Obj < PrettyStruct
      class InternalRep < Union
        class TwoPtrValue < PrettyStruct
          layout(
            :ptr1, :pointer,
            :ptr2, :pointer
          )
        end

        class PtrAndLongRep < PrettyStruct
          layout(
            :ptr,   :pointer,
            :value, :ulong
          )
        end

        layout(
          :longValue,     :long,
          :doubleValue,   :double,
          :otherValuePtr, :pointer,
          :wideValue,     :int64,
          :twoPtrValue,   TwoPtrValue,
          :ptrAndLongRep, PtrAndLongRep
        )
      end

      layout(
        :refCount,    :int,
        :bytes,       :string,
        :length,      :int,
        :type,        ObjType,
        :internalRep, InternalRep
      )
    end
  end
end