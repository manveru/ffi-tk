# frozen_string_literal: true

module FFI
  module Tcl
    # FFI binding for Tcl's Tcl_DictSearch struct, the opaque iteration cursor
    # that Tcl_DictObjFirst fills in and Tcl_DictObjNext advances. The caller
    # must allocate the whole struct (24 bytes on LP64): passing a bare
    # MemoryPointer(:pointer) gives Tcl only 8 bytes to write into and corrupts
    # adjacent heap. FFI sizes and aligns the layout per platform.
    class TclDictSearch < PrettyStruct
      layout(
        :next,          :pointer, # search position in the underlying hash table
        :epoch,         :int,     # epoch marker for the dictionary being searched
        :dictionaryPtr, :pointer  # reference to the dictionary being searched
      )
    end
  end
end
