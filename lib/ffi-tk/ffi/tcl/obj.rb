# frozen_string_literal: true
module FFI
  module Tcl
    # Nicer introspection and some accessors.
    class PrettyStruct < FFI::Struct
      ACCESSOR_CODE = <<-CODE
        def {name}; self[{sym}]; end
        def {name}=(value) self[{sym}] = value; end
      CODE

      def self.layout(*kvs)
        kvs.each_slice(2) do |key, _value|
          eval ACCESSOR_CODE.gsub(/\{(.*?)\}/, '{name}' => key, '{sym}' => ":#{key}")
        end

        super
      end

      def inspect
        kvs = members.zip(values)
        kvs.map! { |key, value| '%s=%s' % [key, value.inspect] }
        '<%s %s>' % [self.class, kvs.join(' ')]
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

      def inspect
        '#<ObjType name=%p>' % [self[:name]]
      end
    end

    class Obj < PrettyStruct
      layout(
        :refCount,    :int,
        :bytes,       :string,
        :length,      :int,
        :type,        :pointer
      )

      def pretty_type
        EvalResult::TYPES[type.to_i]
      end

      def inspect
        '#<Obj bytes=%p type=%p>' % [self[:bytes], pretty_type]
      end
    end
  end
end
