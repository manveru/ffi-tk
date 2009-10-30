module Tk
  class Button < Widget
    include Cget, Configure

    # TODO: implement custom procs
    def initialize(parent, options = {}, &block)
      @parent = parent
      options[:command] = block if block

      Tk.execute('button', assign_pathname, option_hash_to_tcl(options))
    end

    def destroy
      unregister_commands
      super
    end

    def invoke
      execute_only('invoke')
    end
  end
end