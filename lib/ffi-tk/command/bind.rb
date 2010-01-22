module Tk
  module Bind
    def self.bind(tag, sequence = None, &block)
      if None == sequence
        Tk.execute(:bind, tag).to_a
      else
        Event::Handler.register(tag, sequence, &block)
      end
    end

    def bind(sequence = None, &block)
      Bind.bind(tk_pathname, sequence, &block)
    end
  end
end
