require 'ffi'

module FFI
  module Tcl
    class TclTime < FFI::Struct
      layout(
        :sec,  :long, # Seconds
        :usec, :long  # Microseconds
      )

      def initialize(seconds = nil, microseconds = nil)
        super()
        self[:sec] = seconds.to_i if seconds
        self[:usec] = microseconds.to_i if microseconds
      end

      def seconds
        self[:sec]
      end
      alias sec seconds

      def microseconds
        self[:usec]
      end
      alias usec microseconds

      def seconds=(seconds)
        self[:sec] = seconds
      end
      alias sec= seconds=

      def microseconds=(microseconds)
        self[:usec] = microseconds
      end
      alias usec= microseconds=
    end
  end
end