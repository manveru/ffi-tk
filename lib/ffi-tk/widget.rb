# frozen_string_literal: true

module Tk
  # Base class for all Tk widgets.
  # Holds the widget's path name and parent, mixes in the shared Tk commands
  # (geometry management, configuration, binding, window info, ...), and routes
  # method calls to the Tk command backing each widget.
  class Widget
    include TkCmd
    include Place
    include Clipboard
    include Grid
    include Winfo
    include WM
    include Bindtags
    include Bind
    include Destroy
    include Pack

    attr_reader :tk_parent, :tk_pathname

    def self.tk_command
      raise NotImplementedError, 'Implement in subclass'
    end

    def initialize(tk_parent = Tk.root, options = None)
      if tk_parent.respond_to?(:to_tcl_options?)
        options = tk_parent
        tk_parent = Tk.root
      end

      options = if !options || options == None
                  {}
                else
                  options.dup
                end

      @tk_parent = tk_parent

      yield(options) if block_given? && !options[:command]

      command = self.class.tk_command
      Tk.execute(command, assign_pathname, options.to_tcl_options?)
    end

    def to_tcl
      tk_pathname.dump
    end

    def focus(option = None)
      Focus.focus(self, option)
    end

    def focus_next
      Focus.next(self)
    end

    def focus_prev
      Focus.prev(self)
    end

    def raise(above = None)
      Raise.raise(self, above)
    end

    def lower(below = None)
      Lower.lower(self, below)
    end

    def execute(command, *)
      Tk.execute(tk_pathname, command, *)
    end

    def execute_only(command, *)
      Tk.execute_only(tk_pathname, command, *)
    end

    private

    def assign_pathname
      # Memoizes the tk_pathname attribute (attr_reader above), not the method
      # name, so the cop's method-name heuristic does not apply here.
      @tk_pathname ||= Tk.register_object(tk_parent, self) # rubocop:disable Naming/MemoizedInstanceVariableName
    end
  end
end
