# frozen_string_literal: true

module Tk
  # Schedule commands to run after a delay or when the interpreter is idle.
  # Wraps Tk's `after` command.
  module After
    module_function

    def ms(ms, &block)
      if block
        id = nil

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
