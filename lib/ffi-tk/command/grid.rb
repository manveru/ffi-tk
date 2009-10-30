module Tk
  # Geometry manager that arranges widgets in a grid
  module Grid
    def self.slave ?slave ...? ?options?
      Tk.execute('grid', 'slave')
    end

    def self.anchor(master, anchor = None)
      Tk.execute('grid', 'anchor', master, anchor)
    end

    def self.bbox(master, ?column row?, ?column2 row2?)
      Tk.execute('grid', 'bbox', master, *columns)
    end

    def self.columnconfigure(master, index, options = {})
      Tk.execute('grid', 'columnconfigure', master, index, options)
    end

    def self.configure(*arguments)
      Tk.execute('grid', 'configure')

      -column n
      -columnspan n
      -in other
      -ipadx amount
      -ipady amount
      -padx amount
      -pady amount
      -row n
      -rowspan n
      -sticky style
    end

    def self.forget(*slaves)
      Tk.execute('grid', 'forget', *slaves)
    end

    def self.info(slave)
      Tk.execute('grid', 'info', slave)
    end

    def self.location(master, x, y)
      Tk.execute('grid', 'location', master, x, y)
    end

    def self.propagate(master, boolean = None)
      Tk.execute('grid', 'propagate', master, boolean)
    end

    def self.rowconfigure(master, index, options = {})
      Tk.execute('grid', 'rowconfigure', master, index, options)
    end

    def self.remove(*slaves)
      Tk.execute('grid', 'remove', *slaves)
    end

    def self.size(master)
      Tk.execute('grid', 'size', master)
    end

    def self.slaves(master, options = {})
      Tk.execute('grid', 'slaves')
    end

    def grid_slave(options = {})
      Grid.slave(self, options)
    end

    def grid_anchor(anchor = None)
      Grid.anchor(self, anchor)
    end

    def grid_bbox(*columns)
      Grid.bbox(self, *columns)
    end

    def grid_columnconfigure(index, options = {})
      Grid.columnconfigure(self, index, options)
    end

    def grid_configure(options = {})
      Grid.configure(self, options)
    end

    def grid_forget
      Grid.forget(self)
    end

    def grid_info
      Grid.info(self)
    end

    def grid_location(x, y)
      Grid.location(self, x, y
    end

    def grid_propagate(boolean = None)
      Grid.propagate(self, boolean)
    end

    def grid_rowconfigure(master, index, options = {})
      Grid.rowconfigure(self, index, options)
    end

    def grid_remove
      Grid.remove(self)
    end

    def grid_size
      Grid.size(self)
    end

    def grid_slaves(options = {})
      Grid.slaves(self, options)
    end
  end
end