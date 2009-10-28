module FFI
  module Tcl
    # The following structure represents a type of object, which is a particular
    # internal representation for an object plus a set of functions that provide
    # standard operations on objects of that type.
    class ObjType < FFI::Struct
      layout(
        :name, :string,
        :free_internal_rep_proc, :pointer,
        :dup_internal_rep_proc, :pointer,
        :update_string_proc, :pointer,
        :set_from_any_proc, :pointer
      )

      def inspect
        "<Tcl::Obj %p>" % [Hash[members.zip(values)]]
      end
    end

    class Obj < FFI::Struct
      class InternalRep < FFI::Union
        class TwoPtrValue < FFI::Struct
          layout(
            :ptr1, :pointer,
            :ptr2, :pointer
          )
        end

        class PtrAndLongRep < FFI::Struct
          layout(
            :ptr, :pointer,
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

        def inspect
          "<Tcl::Obj %p>" % [Hash[members.zip(values)]]
        end
      end

      layout(
        :refCount,    :int,
        :bytes,       :string,
        :length,      :int,
        :type,     :pointer,
        :internalRep, InternalRep
      )

      def ref_count
        self[:refCount]
      end

      def bytes
        self[:bytes]
      end

      def length
        self[:length]
      end

      def type
        self[:type]
      end

      def internal_rep
        self[:internalRep]
      end

      def to_s
        Tcl.get_unicode(self)
      end

      def inspect
        "<Tcl::Obj %p>" % [Hash[members.zip(values)]]
      end
    end
  end
end