module Tk
  class LabelFrame < Frame
    INITIALIZE_COMMAND = name.downcase.freeze
    include Cget, Configure
  end
end
