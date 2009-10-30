module Tk
  module Bell
    # This command rings the bell on the display for window and returns an empty
    # string.
    # If the :displayof option is omitted, the display of the application's main
    # window is used by default.
    # The command uses the current bell-related settings for the display, which
    # may be modified with programs such as xset.
    #
    # If :nice is not specified, this command also resets the screen saver for
    # the screen. Some screen savers will ignore this, but others will reset so
    # that the screen becomes visible again.
    #
    # @example Usage:
    #   Tk::Bell.bell
    #   Tk::Bell.bell(displayof: '.')
    #   Tk::Bell.bell(nice: true)
    #   Tk::Bell.bell(displayof: '.', nice: true)
    def self.bell(options = {})
      displayof = options[:displayof]
      nice = options[:nice]

      args = []
      args << '-displayof', displayof if displayof
      args << '-nice' if nice
      Tk.execute_only('bell', *args)
    end

    def bell(options = {})
      options[:displayof] ||= tk_pathname
      Bell.bell(options)
    end
  end
end