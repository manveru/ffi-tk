module Tk
  module Focus
    def self.focus(window = None, option = None)
      if window == None
        Tk.execute('focus')
      else
        case option
        when None
          Tk.execute('focus', window)
        when :displayof
          Tk.execute('focus', '-displayof', window)
        when :force
          Tk.execute_only('focus', '-force', window)
        when :lastfor
          Tk.execute('focus', '-lastfor', window)
        end
      end
    end

    def focus(option = None)
      case option
      when None
        Tk.execute('focus', self)
      when :displayof
        Tk.execute('focus', '-displayof', self)
      when :force
        Tk.execute_only('focus', '-force', self)
      when :lastfor
        Tk.execute('focus', '-lastfor', self)
      end
    end
  end
end