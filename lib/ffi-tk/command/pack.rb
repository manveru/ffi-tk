module Tk
  # Geometry manager that packs around edges of cavity
  #
  # The pack command is used to communicate with the packer, a geometry manager
  # that arranges the children of a parent by packing them in order around the
  # edges of the parent.
  module Pack
    # If the first argument to pack is a window name (any value starting with
    # "."), then the command is processed in the same way as [configure].
    def self.pack(*args)
      Tk.execute('pack', *args)
    end

    # The arguments consist of the names of one or more slave windows followed
    # by a hash of arguments that specify how to manage the slaves.
    # See THE PACKER ALGORITHM for details on how the options are used by the
    # packer.
    def self.configure(*arguments)
      Tk.execute('pack', 'configure', *arguments)
    end

    # Removes each of the +slaves+ from the packing order for its master and
    # unmaps their windows.
    # The +slaves+ will no longer be managed by the packer.
    def self.forget(*slaves)
      Tk.execute_only('pack', 'forget', *slaves)
    end

    # Returns a hash whose elements are the current configuration state of the
    # +slave+ given by in the same option-value form that might be specified
    # to pack configure.
    # The hash contains`in: master` where master is the +slave+'s master.
    def self.info(slave)
      info = Tk.execute('pack', 'info', slave)

      array = info.split.each_slice(2).map{|key, value|
        case key = key[1..-1].to_sym
        when :expand
          [key, Tk.boolean(value)]
        when :ipadx, :ipady, :padx, :pady
          [key, value.to_i]
        when :fill, :side
          [key, value.to_sym]
        when :after, :anchor, :before, :in
          [key, value]
        else
          raise "Unknown info pair: %p => %p" % [key, value]
        end
      }

      Hash[array]
    end

    # If +boolean+ is true then propagation is enabled for +master+, which must
    # be a window (see GEOMETRY PROPAGATION below).
    # If +boolean+ is false, then propagation is disabled for +master+.
    # In either of these cases nil is returned.
    # If boolean is omitted then the command returns 0 or 1 to indicate whether
    # propagation is currently enabled for master.
    # Propagation is enabled by default.
    def self.propagate(master, boolean = true)
      Tk.execute_only('pack', 'propagate', master, boolean)
    end

    # Returns a list of all of the slaves in the packing order for master. The
    # order of the slaves in the list is the same as their order in the packing
    # order.
    def self.slaves(master)
      Tk.execute('pack', 'slaves', master)
    end

    def pack(options = {})
      Pack.pack(self, options)
      self
    end

    def pack_configure(options = {})
      Tk.execute_only('pack', 'configure', self, options)
      self
    end

    def pack_forget
      Pack.forget(self)
      self
    end

    def pack_info
      Pack.info(self)
    end

    def pack_propagate(boolean = true)
      Pack.propagate(self, boolean)
    end

    def pack_slaves
      Pack.slaves(self)
    end
  end
end