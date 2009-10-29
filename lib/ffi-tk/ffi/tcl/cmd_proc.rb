module FFI
  module Tcl
    class CmdProc < PrettyStruct
      layout :clientData, :int,
             :interp,     Interp,
             :argc,       :int,
             :argv,       :pointer
    end
  end
end