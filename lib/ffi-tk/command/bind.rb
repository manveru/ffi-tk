module Tk
  module Bind
    def self.bind(tag, sequence = None)
      if None == sequence
        Tk.execute(:bind, tag).to_a
      else
        if block_given?
          Event::Handler.register(tag, sequence, &Proc.new)
        else
          Tk.execute(:bind, tag, sequence).to_s
        end
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
