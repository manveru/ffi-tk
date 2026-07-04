# frozen_string_literal: true

module Tk
  module Bind
    def self.bind(tag, sequence = None, &block)
      if sequence == None
        Tk.execute(:bind, tag).to_a
      elsif block
        Event::Handler.register(tag, sequence, &block)
      else
        Tk.execute(:bind, tag, sequence).to_s
      end
    end

    # TODO: remove the block associated
    def self.unbind(tag, sequence)
      Event::Handler.unregister(tag, sequence)
    end

    def bind(sequence = None, &block)
      Bind.bind(tk_pathname, sequence, &block)
    end

    def unbind(sequence)
      Bind.unbind(tk_pathname, sequence)
    end
  end
end
