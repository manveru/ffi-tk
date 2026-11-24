# frozen_string_literal: true

module Tk
  # Associate Ruby callbacks with X events on a widget.
  # Wraps Tk's `bind` command.
  module Bind
    def self.bind(tag, sequence = None, &block)
      if None.equal?(sequence)
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

    def bind(sequence = None, &)
      Bind.bind(tk_pathname, sequence, &)
    end

    def unbind(sequence)
      Bind.unbind(tk_pathname, sequence)
    end
  end
end
