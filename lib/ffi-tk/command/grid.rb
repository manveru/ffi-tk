module Tk
  # Geometry manager that arranges widgets in a grid
  #
  # The grid command is used to communicate with the grid geometry manager that
  # arranges widgets in rows and columns inside of another window, called the
  # geometry master (or master window).
  module Grid
    # If the first argument to grid is suitable as the first slave argument to
    # grid configure, either a window name (any value starting with .) or one of
    # the characters x or ^ (see the RELATIVE PLACEMENT section below), then the
    # command is processed in the same way as grid configure.
    def self.slave(*arguments)
      Tk.execute('grid', 'slave', *arguments)
    end

    # The anchor value controls how to place the grid within the master when no
    # row/column has any weight.
    # The default anchor is nw.
    def self.anchor(master, anchor = None)
      Tk.execute('grid', 'anchor', master, anchor)
    end

    # With no arguments, the bounding box (in pixels) of the grid is returned.
    # The return value consists of 4 integers.
    #
    # The first two are the pixel offset from the master window (x then y) of
    # the top-left corner of the grid, and the second two integers are the width
    # and height of the grid, also in pixels.
    #
    # If only +col1+ and +row1+ are given, then the bounding box for that cell
    # is returned, where the top left cell is numbered from zero.
    # If +col2+ and +col2+ are given as well, then the bounding box
    # spanning the rows and columns indicated is returned.
    #
    # @usage Example
    #
    #   Bbox.bbox('.', 0, 0) # top left cell
    #   Bbox.bbox('.', 1, 1) # cell in second column and row
    #   Bbox.bbox('.', 0, 0, 1, 1) # cells from top left to second col/row
    def self.bbox(master, col1 = None, row1 = None, col2 = None, row2 = None)
      bbox = Tk.execute('grid', 'bbox', master, column1, row1, column2, row2)
      bbox.map(&:to_i)
    end

    # Query or set the column properties of the index column of the geometry
    # master, master.
    # The valid options are -minsize, -weight, -uniform and -pad.
    # If one or more options are provided, then index may be given as a list of
    # column indices to which the configuration options will operate on.
    # Indices may be integers, window names or the keyword all.
    # For all the options apply to all columns currently occupied be slave
    # windows. For a window name, that window must be a slave of this master and
    # the options apply to all columns currently occupied be the slave.
    # The -minsize option sets the minimum size, in screen units, that will be
    # permitted for this column.
    # The -weight option (an integer value) sets the relative weight for
    # apportioning any extra spaces among columns.
    # A weight of zero (0) indicates the column will not deviate from its
    # requested size.
    # A column whose weight is two will grow at twice the rate as a column of
    # weight one when extra space is allocated to the layout.
    # The -uniform option, when a non-empty value is supplied, places the column
    # in a uniform group with other columns that have the same value for
    # -uniform. The space for columns belonging to a uniform group is allocated
    # so that their sizes are always in strict proportion to their -weight
    # values. See THE GRID ALGORITHM below for further details.
    # The -pad option specifies the number of screen units that will be added to
    # the largest window contained completely in that column when the grid
    # geometry manager requests a size from the containing window.
    # If only an option is specified, with no value, the current value of that
    # option is returned.
    # If only the master window and index is specified, all the current settings
    # are returned in a list of â-option valueâ pairs.
    def self.columnconfigure(master, index, options = {})
      Tk.execute('grid', 'columnconfigure', master, index, options)
    end

    # The arguments consist of the names of one or more slave windows followed
    # by pairs of arguments that specify how to manage the slaves.
    # The characters -, x and ^, can be specified instead of a window name to
    # alter the default location of a slave.
    def self.configure(*arguments)
      Tk.execute('grid', 'configure', *arguments)
    end

    # Removes each of the slaves from grid for its master and unmaps their
    # windows. The slaves will no longer be managed by the grid geometry
    # manager. The configuration options for that window are forgotten, so that
    # if the slave is managed once more by the grid geometry manager, the
    # initial default settings are used.
    def self.forget(*slaves)
      Tk.execute('grid', 'forget', *slaves)
    end

    # Returns a list whose elements are the current configuration state of the
    # slave given by slave in the same option-value form that might be specified
    # to grid configure.
    # The first two elements of the list are â-in masterâ where master is
    # the slave's master.
    def self.info(slave)
      Tk.execute('grid', 'info', slave)
    end

    # Given x and y values in screen units relative to the master window, the
    # column and row number at that x and y location is returned.
    # For locations that are above or to the left of the grid, -1 is returned.
    def self.location(master, x, y)
      Tk.execute('grid', 'location', master, x, y)
    end

    # If boolean has a true boolean value such as 1 or on then propagation is
    # enabled for master, which must be a window name (see GEOMETRY PROPAGATION
    # below). If boolean has a false boolean value then propagation is disabled
    # for master.
    # In either of these cases an empty string is returned.
    # If boolean is omitted then the command returns 0 or 1 to indicate whether
    # propagation is currently enabled for master.
    # Propagation is enabled by default.
    def self.propagate(master, boolean = None)
      Tk.execute('grid', 'propagate', master, boolean)
    end

    # Query or set the row properties of the index row of the geometry master,
    # master. The valid options are -minsize, -weight, -uniform and -pad.
    # If one or more options are provided, then index may be given as a list of
    # row indices to which the configuration options will operate on.
    # Indices may be integers, window names or the keyword all.
    # For all the options apply to all rows currently occupied be slave windows.
    # For a window name, that window must be a slave of this master and the
    # options apply to all rows currently occupied be the slave.
    # The -minsize option sets the minimum size, in screen units, that will be
    # permitted for this row.
    # The -weight option (an integer value) sets the relative weight for
    # apportioning any extra spaces among rows.
    # A weight of zero (0) indicates the row will not deviate from its requested
    # size. A row whose weight is two will grow at twice the rate as a row of
    # weight one when extra space is allocated to the layout.
    # The -uniform option, when a non-empty value is supplied, places the row in
    # a uniform group with other rows that have the same value for -uniform.
    # The space for rows belonging to a uniform group is allocated so that their
    # sizes are always in strict proportion to their -weight values.
    # See THE GRID ALGORITHM below for further details.
    # The -pad option specifies the number of screen units that will be added to
    # the largest window contained completely in that row when the grid geometry
    # manager requests a size from the containing window.
    # If only an option is specified, with no value, the current value of that
    # option is returned.
    # If only the master window and index is specified, all the current settings
    # are returned in a list of â-option valueâ pairs.
    def self.rowconfigure(master, index, options = {})
      Tk.execute('grid', 'rowconfigure', master, index, options)
    end

    # Removes each of the slaves from grid for its master and unmaps their
    # windows. The slaves will no longer be managed by the grid geometry
    # manager. However, the configuration options for that window are
    # remembered, so that if the slave is managed once more by the grid geometry
    # manager, the previous values are retained.
    def self.remove(*slaves)
      Tk.execute('grid', 'remove', *slaves)
    end

    # Returns the size of the grid (in columns then rows) for master.
    # The size is determined either by the slave occupying the largest row or
    # column, or the largest column or row with a minsize, weight, or pad that
    # is non-zero.
    def self.size(master)
      Tk.execute('grid', 'size', master)
    end

    # If no options are supplied, a list of all of the slaves in master are
    # returned, most recently manages first.
    # Option can be either -row or -column which causes only the slaves in the
    # row (or column) specified by value to be returned.
    def self.slaves(master, options = {})
      Tk.execute('grid', 'slaves')
    end

    # @see Grid::slave
    def grid_slave(options = {})
      Grid.slave(self, options)
    end

    # @see Grid::anchor
    def grid_anchor(anchor = None)
      Grid.anchor(self, anchor)
    end

    # @see Grid::bbox
    def grid_bbox(col1 = None, row1 = None, col2 = None, row2 = None)
      Grid.bbox(self, col1, row1, col2, row2)
    end

    # @see Grid::columnconfigure
    def grid_columnconfigure(index, options = {})
      Grid.columnconfigure(self, index, options)
    end

    # @see Grid::configure
    def grid_configure(options = {})
      Grid.configure(self, options)
    end

    # @see Grid::forget
    def grid_forget
      Grid.forget(self)
    end

    # @see Grid::info
    def grid_info
      Grid.info(self)
    end

    # @see Grid::location
    def grid_location(x, y)
      Grid.location(self, x, y)
    end

    # @see Grid::propagte
    def grid_propagate(boolean = None)
      Grid.propagate(self, boolean)
    end

    # @see grid::rowconfigure
    def grid_rowconfigure(master, index, options = {})
      Grid.rowconfigure(self, index, options)
    end

    # @see Grid::remove
    def grid_remove
      Grid.remove(self)
    end

    # @see Grid::size
    def grid_size
      Grid.size(self)
    end

    # @see Grid::slaves
    def grid_slaves(options = {})
      Grid.slaves(self, options)
    end
  end
end