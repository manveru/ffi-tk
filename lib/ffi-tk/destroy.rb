module Tk
  module Destroy
    def self.destroy(*windows)
      Tk.execute_only('destroy', *windows)
    end

    def destroy
      Tk.execute_only('destroy', self)
    end
  end
end