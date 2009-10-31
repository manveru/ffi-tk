module Tk
  module Bind
    def bind(sequence, &block)
      Event::Handler.register(tk_pathname, sequence, &block)
    end
  end
end