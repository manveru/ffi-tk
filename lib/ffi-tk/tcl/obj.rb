module FFI
  module Tcl
    class Obj < FFI::Struct
      class InternalRep < FFI::Union
        layout(
          :longValue,     :long,
          :doubleValue,   :double,
          :otherValuePtr, :pointer,
          :wideValue,     :int64,
          :twoPtrValue,   :pointer,
          :ptrAndLongRep, :pointer
        )

        def inspect
          "#<Tcl::Obj::InternalRep long_value=%p double_value=%p wide_value=%p>" % [
            self[:longValue], self[:doubleValue], self[:wideValue]
          ]
        end
      end

      layout(
        :refCount, :int,
        :bytes, :char,
        :length, :int,
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

      def internal_rep
        self[:internalRep]
      end

      def to_s
        Tcl.get_unicode(self)
      end

      def inspect
        "#<Tcl::Obj ref_count=%p bytes=%p length=%p internal_rep=%p>" % [
          self[:refCount], self[:bytes], self[:length], self[:internalRep]
        ]
      end
    end
  end
end