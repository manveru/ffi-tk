# frozen_string_literal: true
module Tk
  # Geometry manager for fixed or rubber-sheet placement
  #
  # The placer is a geometry manager for Tk. It provides simple fixed placement
  # of windows, where you specify the exact size and location of one window,
  # called the slave, within another window, called the master.
  # The placer also provides rubber-sheet placement, where you specify the size
  # and location of the slave in terms of the dimensions of the master, so that
  # the slave changes size and location in response to changes in the size of
  # the master.
  # Lastly, the placer allows you to mix these styles of placement so that, for
  # example, the slave has a fixed width and height but is centered inside the
  # master.
  module Place
    # Arrange for the placer to manage the geometry of a +window+.
    # The remaining arguments consist of a hash that specifies the way in which
    # +window+'s geometry is managed.
    # Option may have any of the values accepted by [Place.configure].
    def self.place(window, options = {})
      args = options.map { |k, v| ["-#{k}", v] }.flatten
      Tk.execute_only('place', window, *args)
    end

    # Query or modify the geometry options of the slave given by window.
    # If no option is specified, this command returns a list describing the
    # available options (see Tk_ConfigureInfo for information on the format of
    # this list).
    # If option is specified with no value, then the command returns a list
    # describing the one named option (this list will be identical to the
    # corresponding sublist of the value returned if no option is specified).
    # If one or more options are specified, then the command modifies the given
    # option(s) to have the given value(s); in this case the command returns
    # nil.
    def self.configure(window, options = None)
      Configure.common(Tk, [:place, :configure, window], options)
    end

    def self.forget(window)
      Tk.execute_only('place', 'forget', window)
    end

    def self.info(window)
      info = Tk.execute('place', 'info', window).to_s

      array = info.split.each_slice(2).map do |key, value|
        case key = key[1..-1].to_sym
        when :anchor, :in
          [key, value]
        when :bordermode
          [key, value.to_sym]
        when :height, :width, :x, :y
          [key, value.to_i]
        when :relheight, :relwidth, :relx, :rely
          [key, value.to_f]
        else
          raise 'Unknown info pair: %p => %p' % [key, value]
        end
      end

      Hash[array]
    end

    def self.slaves(window)
      Tk.execute('place', 'slaves', window)
    end

    def place(options = {})
      Place.place(self, options)
    end

    def place_configure(options = None)
      Place.configure(self, options)
    end

    def place_forget
      Place.forget(self)
    end

    def place_info
      Place.info(self)
    end

    def place_slaves
      Place.slaves(self)
    end
  end
end
