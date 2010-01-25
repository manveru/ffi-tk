module Tk
  module Winfo
    # @see Winfo.atom
    def winfo_atom(name)
      Winfo.atom(name, self)
    end

    # @see Winfo.atomname
    def winfo_atomname(id)
      Winfo.atomname(id, self)
    end

    # @see Winfo.cells
    def winfo_cells
      Winfo.cells(self)
    end

    # @see Winfo.children
    def winfo_children
      Winfo.children(self)
    end

    # @see Winfo.class_name
    def winfo_class
      Winfo.class_name(self)
    end

    # @see Winfo.colormapfull
    def winfo_colormapfull
      Winfo.colormapfull(self)
    end

    # @see Winfo.containing
    def winfo_containing(root_x, root_y)
      Winfo.containing(root_x, root_y, self)
    end

    # @see Winfo.depth
    def winfo_depth
      Winfo.depth(self)
    end

    # @see Winfo.exists
    def winfo_exists
      Winfo.exists(self)
    end

    # @see Winfo.fpixels
    def winfo_fpixels(number)
      Winfo.fpixels(self, number)
    end

    # @see Winfo.geometry
    def winfo_geometry
      Winfo.geometry(self)
    end

    # @see Winfo.height
    def winfo_height
      Winfo.height(self)
    end

    # @see Winfo.id
    def winfo_id
      Winfo.id(self)
    end

    # @see Winfo.interps
    def winfo_interps
      Winfo.interps(self)
    end

    # @see Winfo.ismapped
    def winfo_ismapped
      Winfo.ismapped(self)
    end

    # @see Winfo.manager
    def winfo_manager
      Winfo.manager(self)
    end

    # @see Winfo.name
    def winfo_name
      Winfo.name(self)
    end

    # @see Winfo.parent
    def winfo_parent
      Winfo.parent(self)
    end

    # @see Winfo.pathname
    def winfo_pathname(id)
      Winfo.pathname(id, self)
    end

    # @see Winfo.pixels
    def winfo_pixels(number)
      Winfo.pixels(self, number)
    end

    # @see Winfo.pointerx
    def winfo_pointerx
      Winfo.pointerx(self)
    end

    # @see Winfo.pointerxy
    def winfo_pointerxy
      Winfo.pointerxy(self)
    end

    # @see Winfo.pointery
    def winfo_pointery
      Winfo.pointery(self)
    end

    # @see Winfo.reqheight
    def winfo_reqheight
      Winfo.reqheight(self)
    end

    # @see Winfo.reqwidth
    def winfo_reqwidth
      Winfo.reqwidth(self)
    end

    # @see Winfo.rgb
    def winfo_rgb(color)
      Winfo.rgb(self, color)
    end

    # @see Winfo.rootx
    def winfo_rootx
      Winfo.rootx(self)
    end

    # @see Winfo.rooty
    def winfo_rooty
      Winfo.rooty(self)
    end

    # @see Winfo.screen
    def winfo_screen
      Winfo.screen(self)
    end

    # @see Winfo.screencells
    def winfo_screencells
      Winfo.screencells(self)
    end

    # @see Winfo.screendepth
    def winfo_screendepth
      Winfo.screendepth(self)
    end

    # @see Winfo.screenheight
    def winfo_screenheight
      Winfo.screenheight(self)
    end

    # @see Winfo.screenmmheight
    def winfo_screenmmheight
      Winfo.screenmmheight(self)
    end

    # @see Winfo.screenmmwidth
    def winfo_screenmmwidth
      Winfo.screenmmwidth(self)
    end

    # @see Winfo.screenvisual
    def winfo_screenvisual
      Winfo.screenvisual(self)
    end

    # @see Winfo.screenwidth
    def winfo_screenwidth
      Winfo.screenwidth(self)
    end

    # @see Winfo.server
    def winfo_server
      Winfo.server(self)
    end

    # @see Winfo.toplevel
    def winfo_toplevel
      Winfo.toplevel(self)
    end

    # @see Winfo.viewable
    def winfo_viewable
      Winfo.viewable(self)
    end

    # @see Winfo.visual
    def winfo_visual
      Winfo.visual(self)
    end

    # @see Winfo.visualid
    def winfo_visualid
      Winfo.visualid(self)
    end

    # @see Winfo.visualsavailable
    def winfo_visualsavailable(includeids = None)
      Winfo.visualsavailable(self, includeids)
    end

    # @see Winfo.vrootheight
    def winfo_vrootheight
      Winfo.vrootheight(self)
    end

    # @see Winfo.vrootwidth
    def winfo_vrootwidth
      Winfo.vrootwidth(self)
    end

    # @see Winfo.vrootx
    def winfo_vrootx
      Winfo.vrootx(self)
    end

    # @see Winfo.vrooty
    def winfo_vrooty
      Winfo.vrooty(self)
    end

    # @see Winfo.width
    def winfo_width
      Winfo.width(self)
    end

    # @see Winfo.x
    def winfo_x
      Winfo.x(self)
    end

    # @see Winfo.y
    def winfo_y
      Winfo.y(self)
    end

    module_function

    # Returns a decimal string giving the integer identifier for the atom whose
    # name is +name+.
    # If no atom exists with the +name+ then a new one is created.
    # If +window+ is given then the atom is looked up on the
    # display of +window+; otherwise it is looked up on the display of the
    # application's main window.
    def atom(name, window = None)
      if None == window
        Tk.execute(:winfo, :atom, name)
      else
        Tk.execute(:winfo, :atom, '-displayof', window, name)
      end
    end

    # Returns the textual name for the atom whose integer identifier is +id+.
    # If +window+ is given then the identifier is looked up on the
    # display of +window+; otherwise it is looked up on the display of the
    # application's main window.
    # This command is the inverse of the [atom] method.
    # It generates an error if no such atom exists.
    def atomname(id, window = None)
      if None == window
        Tk.execute(:winfo, :atomname, id).to_s
      else
        Tk.execute(:winfo, :atomname, '-displayof', window, id).to_s
      end
    end

    # Returns a decimal string giving the number of cells in the color map for
    # window.
    def cells(window)
      Tk.execute(:winfo, :cells, window)
    end

    # Returns a list containing the path names of all the children of window.
    # Top-level windows are returned as children of their logical parents.
    # The list is in stacking order, with the lowest window first, except for
    # Top-level windows which are not returned in stacking order.
    # Use the wm stackorder command to query the stacking order of Top-level
    # windows.
    def children(window)
      Tk.execute(:winfo, :children, window).to_a
    end

    # Returns the class name for window.
    #
    # Note: this shadows the class method, so we call it class_name.
    def class_name(window)
      Tk.execute(:winfo, :class, window).to_s
    end

    # Returns true if the colormap for window is known to be full, false
    # otherwise.
    # The colormap for a window is "known" to be full if the last attempt to
    # allocate a new color on that window failed and this application has not
    # freed any colors in the colormap since the failed allocation.
    def colormapfull(window)
      Tk.execute(:winfo, :colormapfull, window).to_boolean
    end

    # Returns the path name for the window containing the point given by
    # +root_x+ and +root_y+.
    # +root_x+ and +root_y+ are specified in screen units (i.e. any form
    # acceptable to Tk_GetPixels) in the coordinate system of the root
    # window (if a virtual-root window manager is in use then the coordinate
    # system of the virtual root window is used).
    # If +window+ is given then the coordinates refer to the screen containing
    # window; otherwise they refer to the screen of the application's main
    # window.
    # If no window in this application contains the point then nil is returned.
    # In selecting the containing window, children are given higher priority
    # than parents and among siblings the highest one in the stacking order is
    # chosen.
    def containing(root_x, root_y, window = None)
      if None == window
        Tk.execute(:winfo, :containing, root_x, root_y).to_s?
      else
        Tk.execute(:winfo, :containing, '-displayof', window, root_x, root_y).to_s?
      end
    end

    # Returns a decimal string giving the depth of window (number of bits per
    # pixel).
    def depth(window)
      Tk.execute(:winfo, :depth, window)
    end

    # Returns true if there exists a window named window, false if no such
    # window exists.
    def exists(window)
      Tk.execute(:winfo, :exists, window).to_boolean
    end

    # Returns a floating-point value giving the number of pixels in window
    # corresponding to the distance given by number.
    # Number may be specified in any of the forms acceptable to Tk_GetScreenMM,
    # such as "2.0c" or "1i".
    # The return value may be fractional; for an integer value, use winfo
    # pixels.
    def fpixels(window, number)
      Tk.execute(:winfo, :fpixels, window, number)
    end

    # Returns the geometry for window, in the form widthxheight+x+y.
    # All dimensions are in pixels.
    def geometry(window)
      TkGeometry.new(Tk.execute(:winfo, :geometry, window))
    end

    # Returns a decimal string giving window's height in pixels.
    # When a window is first created its height will be 1 pixel; the height
    # will eventually be changed by a geometry manager to fulfill the window's
    # needs. If you need the true height immediately after creating a widget,
    # invoke update to force the geometry manager to arrange it, or use winfo
    # reqheight to get the window's requested height instead of its actual
    # height.
    def height(window)
      Tk.execute(:winfo, :height, window)
    end

    # Returns a hexadecimal string giving a low-level platform-specific
    # identifier for window.
    # On Unix platforms, this is the X window identifier.
    # Under Windows, this is the Windows HWND.
    # On the Macintosh the value has no meaning outside Tk.
    def id(window)
      Tk.execute(:winfo, :id, window).to_s
    end

    # Returns a list whose members are the names of all Tcl interpreters (e.g.
    # all Tk-based applications) currently registered for a particular display.
    # If the -displayof option is given then the return value refers to the
    # display of window; otherwise it refers to the display of the
    # application's main window.
    def interps(window = None)
      if None == window
        Tk.execute(:winfo, :interps).to_a
      else
        Tk.execute(:winfo, :interps, '-displayof', window).to_a
      end
    end

    # Returns true if window is currently mapped, false otherwise.
    def ismapped(window)
      Tk.execute(:winfo, :ismapped, window).to_boolean
    end

    # Returns the name of the geometry manager currently responsible for
    # window, or an empty string if window is not managed by any geometry
    # manager. The name is usually the name of the Tcl command for the geometry
    # manager, such as pack or place.
    # If the geometry manager is a widget, such as canvases or text, the name
    # is the widget's class command, such as canvas.
    def manager(window)
      Tk.execute(:winfo, :manager, window).to_s?
    end

    # Returns window's name (i.e. its name within its parent, as opposed to its
    # full path name).
    # `Winfo.name('.')` will return the name of the application.
    def name(window)
      Tk.execute(:winfo, :name, window).to_s
    end

    # Returns the path name of +window+'s parent, or nil if +window+ is the main
    # window of the application.
    def parent(window)
      Tk.execute(:winfo, :parent, window).to_s?
    end

    # Returns the path name of the window whose X identifier is +id+.
    # +id+ must be a decimal, hexadecimal, or octal integer and must correspond
    # to a window in the invoking application.
    # If +window+ is given then the identifier is looked up on
    # the display of window; otherwise it is looked up on the display of the
    # application's main window.
    def pathname(id, window = None)
      if None == window
        Tk.execute(:winfo, :pathname, id).to_s
      else
        Tk.execute(:winfo, :pathname, '-displayo', window, id).to_s
      end
    end

    # Returns the number of pixels in window corresponding to the distance
    # given by number.
    # Number may be specified in any of the forms acceptable to Tk_GetPixels,
    # such as "2.0c" or "1i".
    # The result is rounded to the nearest integer value; for a fractional
    # result, use winfo fpixels.
    def pixels(window, number)
      Tk.execute(:winfo, :pixels, window, number).to_i
    end

    # If the mouse pointer is on the same screen as window, returns the
    # pointer's x coordinate, measured in pixels in the screen's root window.
    # If a virtual root window is in use on the screen, the position is
    # measured in the virtual root.
    # If the mouse pointer is not on the same screen as window then -1 is
    # returned.
    def pointerx(window)
      Tk.execute(:winfo, :pointerx, window).to_i
    end

    # If the mouse pointer is on the same screen as window, returns a list with
    # two elements, which are the pointer's x and y coordinates measured in
    # pixels in the screen's root window.
    # If a virtual root window is in use on the screen, the position is
    # computed in the virtual root.
    # If the mouse pointer is not on the same screen as window then both of the
    # returned coordinates are -1.
    def pointerxy(window)
      Tk.execute(:winfo, :pointerxy, window).to_a(&:to_i)
    end

    # If the mouse pointer is on the same screen as window, returns the
    # pointer's y coordinate, measured in pixels in the screen's root window.
    # If a virtual root window is in use on the screen, the position is
    # computed in the virtual root.
    # If the mouse pointer is not on the same screen as window then -1 is
    # returned.
    def pointery(window)
      Tk.execute(:winfo, :pointery, window).to_i
    end

    # Returns a decimal string giving window's requested height, in pixels.
    # This is the value used by window's geometry manager to compute its
    # geometry.
    def reqheight(window)
      Tk.execute(:winfo, :reqheight, window)
    end

    # Returns a decimal string giving window's requested width, in pixels.
    # This is the value used by window's geometry manager to compute its
    # geometry.
    def reqwidth(window)
      Tk.execute(:winfo, :reqwidth, window)
    end

    # Returns a list containing three decimal values in the range 0 to 65535,
    # which are the red, green, and blue intensities that correspond to color
    # in the window given by window.
    # Color may be specified in any of the forms acceptable for a color option.
    def rgb(window, color)
      Tk.execute(:winfo, :rgb, window, color).to_a(&:to_i)
    end

    # Returns a decimal string giving the x-coordinate, in the root window of
    # the screen, of the upper-left corner of window's border (or window if it
    # has no border).
    def rootx(window)
      Tk.execute(:winfo, :rootx, window)
    end

    # Returns a decimal string giving the y-coordinate, in the root window of
    # the screen, of the upper-left corner of window's border (or window if it
    # has no border).
    def rooty(window)
      Tk.execute(:winfo, :rooty, window)
    end

    # Returns the name of the screen associated with window, in the form
    # displayName.screenIndex.
    def screen(window)
      Tk.execute(:winfo, :screen, window)
    end

    # Returns a decimal string giving the number of cells in the default color
    # map for window's screen.
    def screencells(window)
      Tk.execute(:winfo, :screencells, window)
    end

    # Returns a decimal string giving the depth of the root window of window's
    # screen (number of bits per pixel).
    def screendepth(window)
      Tk.execute(:winfo, :screendepth, window)
    end

    # Returns a decimal string giving the height of window's screen, in pixels.
    def screenheight(window)
      Tk.execute(:winfo, :screenheight, window)
    end

    # Returns a decimal string giving the height of window's screen, in
    # millimeters.
    def screenmmheight(window)
      Tk.execute(:winfo, :screenmmheight, window)
    end

    # Returns a decimal string giving the width of window's screen, in
    # millimeters.
    def screenmmwidth(window)
      Tk.execute(:winfo, :screenmmwidth, window)
    end

    # Returns one of the following strings to indicate the default visual class
    # for window's screen: directcolor, grayscale, pseudocolor, staticcolor,
    # staticgray, or truecolor.
    def screenvisual(window)
      Tk.execute(:winfo, :screenvisual, window).to_sym
    end

    # Returns a decimal string giving the width of window's screen, in pixels.
    def screenwidth(window)
      Tk.execute(:winfo, :screenwidth, window)
    end

    # Returns a string containing information about the server for window's
    # display. The exact format of this string may vary from platform to
    # platform. For X servers the string has the form:
    #   "XmajorRminor vendor vendorVersion"
    # where major and minor are the version and revision numbers provided by the
    # server (e.g., X11R5), vendor is the name of the vendor for the server, and
    # vendorRelease is an integer release number provided by the server.
    def server(window)
      Tk.execute(:winfo, :server, window)
    end

    # Returns the path name of the top-of-hierarchy window containing window.
    # In standard Tk this will always be a toplevel widget, but extensions may
    # create other kinds of top-of-hierarchy widgets.
    def toplevel(window)
      Tk.execute(:winfo, :toplevel, window).to_s
    end

    # Returns true if window and all of its ancestors up through the nearest
    # toplevel window are mapped.
    # Returns false if any of these windows are not mapped.
    def viewable(window)
      Tk.execute(:winfo, :viewable, window).to_boolean
    end

    # Returns one of the following strings to indicate the visual class for
    # window:
    #   :directcolor, :grayscale, :pseudocolor, :staticcolor, :staticgray,
    #   :truecolor
    def visual(window)
      Tk.execute(:winfo, :visual, window).to_sym
    end

    # Returns the X identifier for the visual for window.
    def visualid(window)
      Tk.execute(:winfo, :visualid, window).to_s
    end

    # Returns a list whose elements describe the visuals available for window's
    # screen. Each element consists of a visual class followed by an integer
    # depth. The class has the same form as returned by winfo visual.
    # The depth gives the number of bits per pixel in the visual.
    # In addition, if the includeids argument is provided, then the depth is
    # followed by the X identifier for the visual.
    def visualsavailable(window, includeids = None)
      if None == includeids
        list = Tk.execute(:winfo, :visualsavailable, window).to_a
        list.uniq.map{|string|
          klass, depth = string.split
          [klass, depth.to_i]
        }
      else
        list = Tk.execute(:winfo, :visualsavailable, window, :includeids).to_a
        list.uniq.map{|string|
          klass, depth, id = string.split
          [klass, depth.to_i, id]
        }
      end
    end

    # Returns the height of the virtual root window associated with window if
    # there is one; otherwise returns the height of window's screen.
    def vrootheight(window)
      Tk.execute(:winfo, :vrootheight, window)
    end

    # Returns the width of the virtual root window associated with window if
    # there is one; otherwise returns the width of window's screen.
    def vrootwidth(window)
      Tk.execute(:winfo, :vrootwidth, window)
    end

    # Returns the x-offset of the virtual root window associated with window,
    # relative to the root window of its screen.
    # This is normally either zero or negative.
    # Returns 0 if there is no virtual root window for window.
    def vrootx(window)
      Tk.execute(:winfo, :vrootx, window)
    end

    # Returns the y-offset of the virtual root window associated with window,
    # relative to the root window of its screen.
    # This is normally either zero or negative.
    # Returns 0 if there is no virtual root window for window.
    def vrooty(window)
      Tk.execute(:winfo, :vrooty, window)
    end

    # Returns a decimal string giving window's width in pixels.
    # When a window is first created its width will be 1 pixel; the width will
    # eventually be changed by a geometry manager to fulfill the window's
    # needs. If you need the true width immediately after creating a widget,
    # invoke update to force the geometry manager to arrange it, or use winfo
    # reqwidth to get the window's requested width instead of its actual width.
    def width(window)
      Tk.execute(:winfo, :width, window)
    end

    # Returns a decimal string giving the x-coordinate, in window's parent, of
    # the upper-left corner of window's border (or window if it has no border).
    def x(window)
      Tk.execute(:winfo, :x, window)
    end

    # Returns a decimal string giving the y-coordinate, in window's parent, of
    # the upper-left corner of window's border (or window if it has no border).
    def y(window)
      Tk.execute(:winfo, :y, window)
    end
  end
end
