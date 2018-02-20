# frozen_string_literal: true
module Tk
  module After
    module_function

    def ms(ms)
      if block_given?
        id = nil
        block = Proc.new

        wrap = lambda do |*_args|
          block.call
          Tk.unregister_proc(id)
          true
        end

        id, command = Tk.register_proc(wrap, 'after_ms')
        Tk.execute_only(:after, ms, command)
      else
        Tk.execute_only(:after, ms)
      end
    end

    def idle
      id = nil

      wrap = lambda do |*_args|
        yield
        Tk.unregister_proc(id)
        true
      end

      id, command = Tk.register_proc(wrap, 'after_idle')
      Tk.execute_only(:after, :idle, command)
    end
  end
end
