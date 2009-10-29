module Tk
  module Bind
    def bind(sequence, &block)
      Event.register_in_tk(tk_pathname, sequence, &block)
    end
  end
end