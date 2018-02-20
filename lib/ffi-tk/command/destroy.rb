# frozen_string_literal: true
module Tk
  module Destroy
    def self.destroy(*windows)
      Tk.unregister_objects(*windows)
      Tk.execute_only('destroy', *windows)
    end

    def destroy
      Destroy.destroy(self)
    end
  end
end
