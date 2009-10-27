module Tk
  module Destroy
    def self.destroy(*windows)
      Tk.execute('destroy', *windows)
    end

    def destroy
      Tk.execute('destroy', self)
    end
  end
end