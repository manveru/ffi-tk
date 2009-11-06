module Tk
  # A button is a widget that displays a textual string, bitmap or image.
  # If text is displayed, it must all be in a single font, but it can occupy
  # multiple lines on the screen (if it contains newlines or if wrapping occurs
  # because of the wrapLength option) and one of the characters may optionally
  # be underlined using the underline option.
  # It can display itself in either of three different ways, according to the
  # state option; it can be made to appear raised, sunken, or flat; and it can
  # be made to flash.
  # When a user invokes the button (by pressing mouse button 1 with the cursor
  # over the button), then the command specified in the -command option is
  # invoked.
  class Button < Widget
    include Cget, Configure

    # TODO: implement custom procs
    def initialize(parent = Tk.root, options = None, &block)
      options[:command] = block if block
      super
    end

    def destroy
      unregister_commands
      super
    end

    def invoke
      execute_only('invoke')
    end

    def flash
      execute_only('flash')
    end
  end
end