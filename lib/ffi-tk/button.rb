module Tk
  class Button < Widget
    include Cget

    # TODO: implement custom procs
    def initialize(parent, options = {}, &block)
      @parent = parent

      if block
        @tk_proc_id, command = Tk.register_proc(block)
        options[:command] = command
      end

      Tk.execute('button', assign_pathname, options)
    end

    def destroy
      Tk.unregister_proc(@tk_proc_id) if @tk_proc_id
      super
    end

    def invoke
      execute_only('invoke')
    end
  end
end