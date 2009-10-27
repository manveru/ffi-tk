module Tk
  module Pack
    # If the first argument to pack is a window name (any value starting with
    # "."), then the command is processed in the same way as [configure].
    def self.pack(*args)
      Tk.execute('pack', *args)
    end

    def pack(options = {})
      Tk.execute('pack', self, options)
      self
    end
  end
end