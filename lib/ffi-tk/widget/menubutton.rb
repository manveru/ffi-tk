module Tk
  class MenuButton < Button
    INITIALIZE_COMMAND = name.downcase.freeze
    include Cget, Configure
  end
end
