module Tk
  module Bind
    def self.bind(pathname, sequence, &block)
      Event::Handler.register(pathname, sequence, &block)
    end

    def bind(sequence, &block)
      Bind.bind(tk_pathname, sequence, &block)
    end
  end
end