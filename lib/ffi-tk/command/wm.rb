# frozen_string_literal: true
module Tk
  # Communicate with window manager
  # The wm command is used to interact with window managers in order to control
  # such things as the title for a window, its geometry, or the increments in
  # terms of which it may be resized.
  # All of the methods expect at least one additional argument, window, which
  # must be the path name of a top-level window.
  module WM
    # @see WM::aspect
    def wm_aspect
      WM.aspect(self)
    end

    # @see WM::aspect
    def wm_aspect=(aspects)
      WM.aspect(self, *[aspects].flatten)
    end

    # @see WM::attributes
    def wm_attributes(options = None)
      WM.attributes(self, options)
    end

    # @see WM::client
    def wm_client
      WM.client(self)
    end

    def wm_client=(name)
      WM.client(self, name)
    end

    # @see WM::colormapwindows
    def wm_colormapwindows
      WM.colormapwindows(self)
    end

    def wm_colormapwindows=(windows)
      WM.colormapwindows(self, *windows)
    end

    # @see WM::command
    def wm_command
      WM.command(self)
    end

    # @see WM::command
    def wm_command=(value)
      WM.command(self, value)
    end

    # @see WM::deiconify
    def wm_deiconify
      WM.deiconify(self)
    end

    # @see WM::focusmodel
    def wm_focusmodel
      WM.focusmodel(self)
    end

    # @see WM::focusmodel
    def wm_focusmodel=(model)
      WM.focusmodel(self, model)
    end

    # @see WM::forget
    def wm_forget
      WM.forget(self)
    end

    # @see WM::frame
    def wm_frame
      WM.frame(self)
    end

    # @see WM::geometry
    def wm_geometry
      WM.geometry(self)
    end

    # @see WM::geometry
    def wm_geometry=(new_geometry)
      WM.geometry(self, new_geometry)
    end

    # @see WM::grid
    def wm_grid
      WM.grid(self)
    end

    def wm_grid=(grid_info)
      WM.grid(self, *[grid_info].flatten)
    end

    # @see WM::group
    def wm_group
      WM.group(self)
    end

    # @see WM::group
    def wm_group=(pathname)
      WM.group(self, pathname)
    end

    # @see WM::iconbitmap
    def wm_iconbitmap
      WM.iconbitmap(self)
    end

    # @see WM::iconbitmap
    def wm_iconbitmap=(bitmap)
      WM.iconbitmap(self, bitmap)
    end

    # @see WM::iconbitmap_default
    def wm_iconbitmap_default
      WM.iconbitmap_default(self)
    end

    # @see WM::iconbitmap_default
    def wm_iconbitmap_default=(image)
      WM.iconbitmap_default(self, image)
    end

    # @see WM::iconify
    def wm_iconify
      WM.iconify(self)
    end

    # @see WM::iconmask
    def wm_iconmask
      WM.iconmask(self)
    end

    # @see WM::iconmask
    def wm_iconmask=(bitmap)
      WM.iconmask(self, bitmap)
    end

    # @see WM::iconname
    def wm_iconname(new_name = None)
      WM.iconname(self, new_name)
    end

    # @see WM::iconname
    def wm_iconname=(new_name)
      WM.iconname(self, new_name)
    end

    # @see WM::iconphoto
    def wm_iconphoto(image, *images)
      WM.iconphoto(self, image, *images)
    end

    # @see WM::iconphoto
    def wm_iconphoto=(*images)
      WM.iconphoto(self, *images)
    end

    # @see WM::iconphoto_default
    def wm_iconphoto_default(image, *images)
      WM.iconphoto_default(self, image, *images)
    end

    # @see WM::iconphoto_default
    def wm_iconphoto_default=(*images)
      WM.iconphoto_default(self, *images)
    end

    # @see WM::iconposition
    def wm_iconposition(y = None, x = None)
      WM.iconposition(self, y, x)
    end

    # @see WM::iconposition
    def wm_iconposition=(yx)
      WM.iconposition(self, *yx)
    end

    # @see WM::iconwindow
    def wm_iconwindow
      WM.iconwindow(self)
    end

    # @see WM::iconwindow
    def wm_iconwindow=(pathname)
      WM.iconwindow(self, pathname)
    end

    # @see WM::manage
    def wm_manage
      WM.manage(self)
    end

    # @see WM::maxsize
    def wm_maxsize(width = None, height = None)
      WM.maxsize(self, width, height)
    end

    # @see WM::minsize
    def wm_minsize(width = None, height = None)
      WM.minsize(self, width, height)
    end

    # @see WM::overrideredirect
    def wm_overrideredirect
      WM.overrideredirect(self)
    end

    # @see WM::overrideredirect
    def wm_overrideredirect=(boolean)
      WM.overrideredirect(self, boolean)
    end

    # @see WM::positionfrom
    def wm_positionfrom
      WM.positionfrom(self)
    end

    # @see WM::positionfrom
    def wm_positionfrom=(who)
      WM.positionfrom(self, who)
    end

    # @see WM::protocol
    def wm_protocol(name = None, command = None, &block)
      WM.protocol(self, name, command, &block)
    end

    # @see WM::resizable
    def wm_resizable(width = None, height = None)
      WM.resizable(self, width, height)
    end

    # @see WM::sizefrom
    def wm_sizefrom
      WM.sizefrom(self)
    end

    # @see WM::sizefrom
    def wm_sizefrom=(who)
      WM.sizefrom(self, who)
    end

    # @see WM::stackorder
    def wm_stackorder(order = None, other_window = None)
      WM.stackorder(self, order, other_window)
    end

    # @see WM::state
    def wm_state
      WM.state(self)
    end

    # @see WM::state
    def wm_state=(new_state)
      WM.state(self, new_state)
    end

    # @see WM::title
    def wm_title
      WM.title(self)
    end

    def wm_title=(string)
      WM.title(self, string)
    end

    # @see WM::transient
    def wm_transient
      WM.transient(self)
    end

    # @see WM::transient
    def wm_transient=(master)
      WM.transient(self, master)
    end

    # @see WM::withdraw
    def wm_withdraw
      WM.withdraw(self)
    end

    module_function

    # If minNumer, minDenom, maxNumer, and maxDenom are all specified, then they
    # will be passed to the window manager and the window manager should use
    # them to enforce a range of acceptable aspect ratios for window.
    # The aspect ratio of window (width/length) will be constrained to lie
    # between minNumer/minDenom and maxNumer/maxDenom.
    # If minNumer etc. are all specified as empty strings, then any existing
    # aspect ratio restrictions are removed.
    # If minNumer etc. are specified, then the command returns nil.
    # Otherwise, it returns a Tcl list containing four elements, which are the
    # current values of minNumer, minDenom, maxNumer, and maxDenom (if no aspect
    # restrictions are in effect, then nil is returned).
    def aspect(window, min_numer = None, min_denom = None, max_numer = None, max_denom = None)
      if min_numer == None
        result = Tk.execute(:wm, :aspect, window)
        result.to_s == '' ? nil : result.to_a(&:to_i)
      elsif min_numer.nil?
        Tk.execute_only(:wm, :aspect, window, '', '', '', '')
      else
        result = Tk.execute_only(:wm, :aspect, window,
                                 min_numer, min_denom, max_numer, max_denom)
        if result.to_s == ''
          nil
        else
          result
        end
      end
    end

    # This methods returns or sets platform specific attributes associated with
    # a window.
    # The first form returns a list of the platform specific flags and their
    # values. The second form returns the value for the specific option.
    # The third form sets one or more of the values.
    # The options are as follows:
    #
    # All platforms support the following attributes (though X11 users should
    # see the notes below):
    #
    #   :fullscreen
    #      Places the window in a mode that takes up the entire screen, has no
    #      borders, and covers the general use area (i.e.
    #      Start menu and taskbar on Windows, dock and menubar on OSX, general
    #      window decorations on X11).
    #
    #   :topmost
    #      Specifies whether this is a topmost window (displays above all other
    #      windows).
    #
    # On Windows, the following attributes may be set.
    #
    #   :alpha
    #       Specifies the alpha transparency level of the toplevel.
    #       It accepts a value from 0.0 (fully transparent) to 1.0 (opaque).
    #       Values outside that range will be constrained.
    #       This is supported on Windows 2000/XP+.
    #       Where not supported, the :alpha value remains at 1.0.
    #
    #   :disabled
    #      Specifies whether the window is in a disabled state.
    #
    #   :toolwindow
    #      Specifies a toolwindow style window (as defined in the MSDN).
    #
    #   :transparentcolor
    #     Specifies the transparent color index of the toplevel.
    #     It takes any color value accepted by Tk_GetColor.
    #     If the empty string is specified (default), no transparent color is
    #     used. This is supported on Windows 2000/XP+.
    #     Where not supported, the :transparentcolor value remains at {}.
    #
    # On Mac OS X, the following attributes may be set.
    #
    #   :alpha
    #     Specifies the alpha transparency level of the window.
    #     It accepts a value from 0.0 (fully transparent) to 1.0 (opaque),
    #     values outside that range will be constrained.
    #
    #   :modified
    #     Specifies the modification state of the window (determines whether the
    #     window close widget contains the modification indicator and whether
    #     the proxy icon is draggable).
    #
    #   :notify
    #      Specifies process notification state (bouncing of the application
    #      dock icon).
    #
    #   :titlepath
    #     Specifies the path of the file referenced as the window proxy icon
    #     (which can be dragged and dropped in lieu of the file's finder icon).
    #
    #   :transparent
    #     Makes the window content area transparent and turns off the window
    #     shadow. For the transparency to be effecive, the toplevel background
    #     needs to be set to a color with some alpha, e.g.
    #     ?systemTransparent?.
    #
    # On X11, the following attributes may be set.  These are not supported by all window managers, and will have no effect under older WMs.
    #
    #   :zoomed
    #     Requests that the window should be maximized.
    #     This is the same as wm state zoomed on Windows and Mac OS X.
    #
    # On X11, changes to window attributes are performed asynchronously.
    # Querying the value of an attribute returns the current state, which will
    # not be the same as the value most recently set if the window manager has
    # not yet processed the request or if it does not support the attribute.
    def attributes(window, options = None)
      if options == None
        result = Tk.execute(:wm, :attributes, window)
        result.tcl_options_to_hash(WM_ATTRIBUTES_HINTS)
      elsif options.respond_to?(:to_tcl_options)
        Tk.execute_only(:wm, :attributes, window, options.to_tcl_options)
      elsif options.respond_to?(:to_tcl_option)
        option = options.to_tcl_option
        value = Tk.execute(:wm, :attributes, window, options.to_tcl_option)
        value.tcl_to_ruby(option, WM_ATTRIBUTES_HINTS)
      else
        raise ArgumentError
      end
    end

    WM_ATTRIBUTES_HINTS = {
      alpha:      :float,
      topmost:    :boolean,
      zoomed:     :boolean,
      fullscreen: :boolean
    }.freeze

    # If name is specified, this command stores name (which should be the name
    # of the host on which the application is executing) in window's
    # WM_CLIENT_MACHINE property for use by the window manager or session
    # manager. The command returns nil in this case.
    # If name is not specified, the command returns the last name set in a wm
    # client command for window.
    # If name is specified as nil, the command deletes the
    # WM_CLIENT_MACHINE property from window.
    def client(window, name = None)
      if name == None
        Tk.execute(:wm, :client, window)
      else
        Tk.execute_only(:wm, :client, window, name)
      end
    end

    # This command is used to manipulate the WM_COLORMAP_WINDOWS property, which
    # provides information to the window managers about windows that have
    # private colormaps.
    #
    # If windowList is not specified, the command returns a list whose elements
    # are the names of the windows in the WM_COLORMAP_WINDOWS property.
    # If windowList is specified, it consists of a list of window path names;
    # the command overwrites the WM_COLORMAP_WINDOWS property with the given
    # windows and returns nil.
    # The WM_COLORMAP_WINDOWS property should normally contain a list of the
    # internal windows within window whose colormaps differ from their parents.
    #
    # The order of the windows in the property indicates a priority order: the
    # window manager will attempt to install as many colormaps as possible from
    # the head of this list when window gets the colormap focus.
    # If window is not included among the windows in windowList, Tk implicitly
    # adds it at the end of the WM_COLORMAP_WINDOWS property, so that its
    # colormap is lowest in priority.
    # If wm colormapwindows is not invoked, Tk will automatically set the
    # property for each top-level window to all the internal windows whose
    # colormaps differ from their parents, followed by the top-level itself; the
    # order of the internal windows is undefined.
    # See the ICCCM documentation for more information on the
    # WM_COLORMAP_WINDOWS property.
    def colormapwindows(window, *windows)
      if windows.empty?
        Tk.execute(:wm, :colormapwindows, window).to_a
      else
        Tk.execute_only(:wm, :colormapwindows, window, *windows)
      end
    end

    # If value is specified, this command stores value in window's WM_COMMAND
    # property for use by the window manager or session manager and returns an
    # empty string.
    # Value must have proper list structure; the elements should contain the
    # words of the command used to invoke the application.
    # If value is not specified then the command returns the last value set in a
    # wm command command for window.
    # If value is specified as nil, the command deletes the
    # WM_COMMAND property from window.
    def command(window, value = None)
      if value == None
        Tk.execute(:wm, :command, window)&.split
      else
        Tk.execute_only(:wm, :command, window, value)
      end
    end

    # Arrange for window to be displayed in normal (non-iconified) form.
    # This is done by mapping the window.
    # If the window has never been mapped then this command will not map the
    # window, but it will ensure that when the window is first mapped it will be
    # displayed in de-iconified form.
    # On Windows, a deiconified window will also be raised and be given the
    # focus (made the active window).
    def deiconify(window)
      Tk.execute_only(:wm, :deiconify, window)
    end

    # If active or passive is supplied as an optional argument to the command,
    # then it specifies the focus model for window.
    # In this case the command returns nil.
    # If no additional argument is supplied, then the command returns the
    # current focus model for window.
    #
    # An active focus model means that window will claim the input focus for
    # itself or its descendants, even at times when the focus is currently in
    # some other application.
    # Passive means that win? dow will never claim the focus for itself: the
    # window manager should give the focus to window at appropriate times.
    # However, once the focus has been given to window or one of its descen?
    # dants, the application may re-assign the focus among window's descendants.
    # The focus model defaults to passive, and Tk's focus command assumes a
    # passive model of focusing.
    def focusmodel(window, model = None)
      if model == None
        Tk.execute(:wm, :focusmodel, window).to_sym
      else
        Tk.execute_only(:wm, :focusmodel, window, model)
      end
    end

    # The window will be unmapped from the screen and will no longer be managed
    # by wm.
    # Windows created with the toplevel command will be treated like frame
    # windows once they are no longer managed by wm, however, the :menu
    # configuration will be remembered and the menus will return once the widget
    # is managed again.
    def forget(window)
      Tk.execute(:wm, :forget, window)
    end

    # If window has been reparented by the window manager into a decorative
    # frame, the command returns the platform specific window identifier for the
    # outermost frame that contains window (the window whose parent is the
    # root or virtual root).
    # If window has not been reparented by the window manager then the command
    # returns the platform specific window identifier for window.
    def frame(window)
      Tk.execute(:wm, :frame, window).to_s
    end

    # If newGeometry is specified, then the geometry of window is changed and an
    # empty string is returned.
    # Otherwise the current geometry for window is returned (this is the most
    # recent geometry specified either by manual resizing or in a wm geometry
    # command). NewGeometry has the form =widthxheight?x?y, where any of =,
    # widthxheight, or ?x?y may be omitted.
    # Width and height are posi? tive integers specifying the desired dimensions
    # of window.
    # If window is gridded (see GRIDDED GEOMETRY MANAGEMENT below) then the
    # dimensions are specified in grid units; otherwise they are specified in
    # pixel units.
    #
    # X and y specify the desired location of window on the screen, in pixels.
    # If x is preceded by +, it specifies the number of pixels between the left
    # edge of the screen and the left edge of win? dow's border; if preceded by
    # - then x specifies the number of pixels between the right edge of the
    # screen and the right edge of window's border.
    # If y is preceded by + then it specifies the number of pixels between the
    # top of the screen and the top of window's border; if y is preceded by -
    # then it specifies the number of pixels between the bottom of window's
    # border and the bot? tom of the screen.
    #
    # If newGeometry is specified as nil then any existing
    # user-specified geometry for window is cancelled, and the window will
    # revert to the size requested internally by its widgets.
    def geometry(window, new_geometry = None)
      if new_geometry == None
        TkGeometry.new(Tk.execute(:wm, :geometry, window))
      else
        Tk.execute_only(:wm, :geometry, window, new_geometry)
      end
    end

    # This command indicates that window is to be managed as a gridded window.
    # It also specifies the relationship between grid units and pixel units.
    # BaseWidth and baseHeight specify the number of grid units corresponding to
    # the pixel dimensions requested internally by window using
    # Tk_GeometryRequest. WidthInc and heightInc specify the number of pixels in
    # each horizontal and vertical grid unit.
    # These four values determine a range of acceptable sizes for window,
    # corresponding to grid-based widths and heights that are non-negative
    # integers. Tk will pass this information to the window manager; during
    # manual resizing, the window manager will restrict the window's size to one
    # of these acceptable sizes.
    #
    # Furthermore, during manual resizing the window manager will display the
    # window's current size in terms of grid units rather than pixels.
    # If baseWidth etc.
    # are all specified as empty strings, then window will no longer be managed
    # as a gridded window.
    # If baseWidth etc.
    # are specified then the return value is nil.
    #
    # Otherwise the return value is a Tcl list containing four elements
    # corresponding to the current baseWidth, baseHeight, widthInc, and
    # heightInc; if window is not currently gridded, then nil is
    # returned.
    #
    # Note: this command should not be needed very often, since the Tk_SetGrid
    # library procedure and the setGrid option provide easier access to the same
    # functionality.
    def grid(window, base_width = None, base_height = None, width_inc = None, height_inc = None)
      if base_width == None
        Tk.execute(:wm, :grid, window)
      else
        Tk.execute_only(:wm, :grid, window, base_width, base_height, width_inc, height_inc)
      end
    end

    # If pathName is specified, it gives the path name for the leader of a group
    # of related windows.
    # The window manager may use this information, for example, to unmap all of
    # the windows in a group when the group's leader is iconified.
    # PathName may be specified as nil to remove window from any
    # group association.
    # If pathName is specified then the command returns nil;
    # otherwise it returns the path name of window's current group leader, or nil
    # if window is not part of any group.
    def group(window, pathname = None)
      if None == pathname
        Tk.execute(:wm, :group, window)
      else
        Tk.execute_only(:wm, :group, window, pathname)
      end
    end

    # wm iconbitmap window ?bitmap?
    # If bitmap is specified, then it names a bitmap in the standard forms
    # accepted by Tk (see the Tk_GetBitmap manual entry for details).
    # This bitmap is passed to the window manager to be dis? played in window's
    # icon, and the command returns nil.
    # If nil is specified for bitmap, then any current icon bitmap
    # is cancelled for window.
    # If bitmap is specified then the command returns nil.
    # Otherwise it returns the name of the current icon bitmap associated with
    # window, or nil if window has no icon bitmap.
    # On the Windows operating system, an additional flag is supported:
    def iconbitmap(window, bitmap = None)
      if None == bitmap
        Tk.execute(:wm, :iconbitmap, window)
      else
        Tk.execute_only(:wm, :iconbitmap, window, bitmap)
      end
    end

    # If the -default flag is given, the icon is applied to all toplevel windows
    # (existing and future) to which no other specific icon has yet been
    # applied.
    # In addition to bitmap image types, a full path specification to any file
    # which contains a valid Windows icon is also accepted (usually .ico or .icr
    # files), or any file for which the shell has assigned an icon.
    # Tcl will first test if the file contains an icon, then if it has an
    # assigned icon, and finally, if that fails, test for a bitmap.
    def iconbitmap_default(window, image = None)
      Tk.execute(:wm, :iconbitmap, window, '-default', image)
    end

    # Arrange for window to be iconified.
    # It window has not yet been mapped for the first time, this command will
    # arrange for it to appear in the iconified state when it is eventually
    # mapped.
    def iconify(window)
      Tk.execute_only(:wm, :iconify, window)
    end

    # If bitmap is specified, then it names a bitmap in the standard forms
    # accepted by Tk (see the Tk_GetBitmap manual entry for details).
    # This bitmap is passed to the window manager to be used as a mask in
    # conjunction with the iconbitmap option: where the mask has zeroes no icon
    # will be displayed; where it has ones, the bits from the icon bitmap will
    # be displayed.
    # If nil is specified for bitmap then any current icon mask is
    # cancelled for window (this is equivalent to specifying a bitmap of all
    # ones). If bitmap is specified then the command returns nil.
    # Otherwise it returns the name of the current icon mask associated with
    # window, or nil if no mask is in effect.
    def iconmask(window, bitmap = None)
      if None == bitmap
        Tk.execute(:wm, :iconmask, window).to_s?
      else
        Tk.execute_only(:wm, :iconmask, window, bitmap)
      end
    end

    # If newName is specified, then it is passed to the window manager; the
    # window manager should display newName inside the icon associated with
    # window. In this case nil is returned as result.
    # If newName is not specified then the command returns the current icon name
    # for window, or nil if no icon name has been specified (in this
    # case the window manager will normally display the window's title, as
    # specified with the wm title command).
    def iconname(window, new_name = None)
      if None == new_name
        Tk.execute(:wm, :iconname, window).to_s?
      else
        Tk.execute_only(:wm, :iconname, window, new_name)
      end
    end

    # Sets the titlebar icon for window based on the named photo images.
    #
    # The data in the images is taken as a snapshot at the time of invocation.
    # If the images are later changed, this is not reflected to the titlebar
    # icons. Multiple images are accepted to allow different images sizes (e.g.,
    # 16x16 and 32x32) to be provided.
    # The window manager may scale provided icons to an appropriate size.
    #
    # On Windows, the images are packed into a Windows icon structure.
    # This will override an ico specified to wm iconbitmap, and vice versa.
    #
    # On X, the images are arranged into the _NET_WM_ICON X property, which most
    # modern window managers support.
    # A wm iconbitmap may exist simultaneously.
    # It is recommended to use not more than 2 icons, placing the larger icon
    # first.
    #
    # On Macintosh, this currently does nothing.
    #
    # @see iconphoto_default
    def iconphoto(window, image, *images)
      Tk.execute_only(:wm, :iconphoto, window, image, *images)
    end

    # If -default is specified, this is applied to all future created toplevels
    # as well.
    #
    # @see iconphoto
    def iconphoto_default(window, image, *images)
      Tk.execute_only(:wm, :iconphoto, window, '-default', image, *images)
    end

    # If x and y are specified, they are passed to the window manager as a hint
    # about where to position the icon for window.
    # In this case an empty string is returned.
    # If x and y are specified as empty strings then any existing icon position
    # hint is cancelled.
    # If neither x nor y is specified, then the command returns a Tcl list
    # containing two values, which are the current icon position hints (if no
    # hints are in effect then an empty string is returned).
    def iconposition(window, y = None, x = None)
      if y == None || x == None
        Tk.execute_only(:wm, :iconposition, window)
      else
        Tk.execute(:wm, :iconposition, window, y, x)
      end
    end

    # If pathName is specified, it is the path name for a window to use as icon
    # for window: when window is iconified then pathName will be mapped to serve
    # as icon, and when window is de-iconified then pathName will be unmapped
    # again. If pathName is specified as an empty string then any existing icon
    # window association for window will be cancelled.
    # If the pathName argument is specified then an empty string is returned.
    # Otherwise the command returns the path name of the current icon window for
    # window, or an empty string if there is no icon window currently specified
    # for window.
    # Button press events are disabled for window as long as it is an icon
    # window; this is needed in order to allow window managers to ?own? those
    # events. Note: not all window managers support the notion of an icon
    # window.
    def iconwindow(window, pathname = None)
      if pathname == None
        Tk.execute_only(:wm, :iconwindow, window)
      else
        Tk.execute(:wm, :iconwindow, window, pathname)
      end
    end

    # The widget specified will become a stand alone top-level window.
    # The window will be decorated with the window managers title bar, etc.
    # Only frame, labelframe and toplevel widgets can be used with this command.
    # Attempting to pass any other widget type will raise an error.
    # Attempting to manage a toplevel widget is benign and achieves nothing.
    # See also GEOMETRY MANAGEMENT.
    def manage(widget)
      Tk.execute_only(:wm, :manage, widget)
    end

    # If width and height are specified, they give the maximum permissible
    # dimensions for window.
    # For gridded windows the dimensions are specified in grid units; otherwise
    # they are specified in pixel units.
    # The window manager will restrict the window's dimensions to be less than
    # or equal to width and height.
    # If width and height are specified, then the command returns an empty
    # string. Otherwise it returns a Tcl list with two elements, which are the
    # maximum width and height currently in effect.
    # The maximum size defaults to the size of the screen.
    # See the sections on geometry management below for more information.
    def maxsize(_window, width = None, height = None)
      if width == None || height == None
        Tk.execute(:wm, :maxsize)
      else
        Tk.execute_only(:wm, :maxsize, width, height)
      end
    end

    # If width and height are specified, they give the minimum permissible
    # dimensions for window.
    # For gridded windows the dimensions are specified in grid units; otherwise
    # they are specified in pixel units.
    # The window manager will restrict the window's dimensions to be greater
    # than or equal to width and height.
    # If width and height are specified, then the command returns an empty
    # string. Otherwise it returns a Tcl list with two elements, which are the
    # minimum width and height currently in effect.
    # The minimum size defaults to one pixel in each dimension.
    # See the sections on geometry management below for more information.
    def minsize(window, width = None, height = None)
      if width == None || height == None
        Tk.execute(:wm, :minsize, window)
      else
        Tk.execute_only(:wm, :minsize, window, width, height)
      end
    end

    # If boolean is specified, it must have a proper boolean form and the
    # override-redirect flag for window is set to that value.
    # If boolean is not specified then 1 or 0 is returned to indicate whether or
    # not the override-redirect flag is currently set for window.
    # Setting the override-redirect flag for a window causes it to be ignored by
    # the window manager; among other things, this means that the window will
    # not be reparented from the root window into a decorative frame and the
    # user will not be able to manipulate the window using the normal window
    # manager mechanisms.
    def overrideredirect(window, boolean = None)
      if boolean == None
        Tk.boolean(Tk.execute(:wm, :overrideredirect, window))
      else
        Tk.execute(:wm, :overrideredirect, window, boolean ? true : false)
      end
    end

    # If who is specified, it must be either program or user, or an abbreviation
    # of one of these two.
    # It indicates whether window's current position was requested by the
    # program or by the user.
    # Many window managers ignore program-requested initial positions and ask
    # the user to manually position the window; if user is specified then the
    # window manager should position the window at the given place without
    # asking the user for assistance.
    # If who is specified as an empty string, then the current position source
    # is cancelled.
    # If who is specified, then the command returns an empty string.
    # Otherwise it returns user or program to indicate the source of the
    # window's current position, or an empty string if no source has been
    # specified yet.
    # Most window managers interpret ?no source? as equivalent to program.
    # Tk will automatically set the position source to user when a wm geometry
    # command is invoked, unless the source has been set explicitly to program.
    def positionfrom(window, who = None)
      if who == None
        Tk.execute_only(:wm, :positionfrom, window, who)
      else
        Tk.execute(:wm, :positionfrom, window)
      end
    end

    # This command is used to manage window manager protocols such as
    # WM_DELETE_WINDOW. Name is the name of an atom corresponding to a window
    # manager protocol, such as WM_DELETE_WINDOW or WM_SAVE_YOURSELF or
    # WM_TAKE_FOCUS. If both name and command are specified, then command is
    # associated with the protocol specified by name.
    # Name will be added to window's WM_PROTOCOLS property to tell the window
    # manager that the application has a protocol handler for name, and command
    # will be invoked in the future whenever the window manager sends a message
    # to the client for that protocol.
    # In this case the command returns an empty string.
    # If name is specified but command is not, then the current command for name
    # is returned, or an empty string if there is no handler defined for name.
    # If command is specified as an empty string then the current handler for
    # name is deleted and it is removed from the WM_PROTOCOLS property on
    # window; an empty string is returned.
    # Lastly, if neither name nor command is specified, the command returns a
    # list of all the protocols for which handlers are currently defined for
    # window.
    #
    # @example assign protocol handler
    #   WM.protocol(window, 'WM_DELETE_WINDOW'){ do_stuff }
    #
    # @example delete protocol handler
    #   WM.protocol(window, 'WM_DELETE_WINDOW', nil)
    #
    # @example show protocol handler
    #   WM.protocol(window, 'WM_DELETE_WINDOW')
    #
    # @example list protocol handlers
    #   WM.protocol(window)
    #
    # Tk always defines a protocol handler for WM_DELETE_WINDOW, even if you
    # have not asked for one with wm protocol.
    # If a WM_DELETE_WINDOW message arrives when you have not defined a handler,
    # then Tk handles the message by destroying the window for which it was
    # received.
    def protocol(window, name = None, command = None, &block)
      command = block if block && !command.nil?
      @commands ||= {}
      key = [window, name]

      if name == None
        Tk.execute(:wm, :protocol, window).to_a
      elsif name != None && command == None
        Tk.execute(:wm, :protocol, window, name)
      elsif name != None && command.nil?
        if id = @commands[key]
          Tk.unregister_proc(id)
          @commands.delete(key)
        end

        Tk.execute_only(:wm, :protocol, window, name, '')
      elsif name != None && command
        if id = @commands[key]
          Tk.unregister_proc(id)
        end

        id, tcl_command = Tk.register_proc(command, '')
        @commands[key] = id

        Tk.execute_only(:wm, :protocol, window, name, tcl_command)
      else
        raise ArgumentError
      end
    end

    # This command controls whether or not the user may interactively resize a
    # top-level window.
    # If width and height are specified, they are boolean values that determine
    # whether the width and height of window may be modified by the user.
    # In this case the command returns an empty string.
    # If width and height are omitted then the command returns a list with two
    # 0/1 elements that indicate whether the width and height of window are
    # currently resizable.
    # By default, windows are resizable in both dimensions.
    # If resizing is disabled, then the window's size will be the size from the
    # most recent interactive resize or wm geometry command.
    # If there has been no such operation then the window's natural size will be
    # used.
    def resizable(window, width = None, height = None)
      if width == None || height == None
        Tk.execute(:wm, :resizable, window)
      else
        Tk.execute_only(:wm, :resizable, window, width, height)
      end
    end

    # If who is specified, it must be either program or user, or an abbreviation
    # of one of these two.
    # It indicates whether window's current size was requested by the program or
    # by the user.
    # Some window managers ignore program-requested sizes and ask the user to
    # manually size the window; if user is specified then the window manager
    # should give the window its specified size without asking the user for
    # assistance. If who is specified as an empty string, then the current size
    # source is cancelled.
    # If who is specified, then the command returns an empty string.
    # Otherwise it returns user or window to indicate the source of the window's
    # current size, or an empty string if no source has been specified yet.
    # Most window managers interpret ?no source? as equivalent to program.
    def sizefrom(window, who = None)
      if who == None
        Tk.execute(:wm, :sizefrom, window)
      else
        Tk.execute_only(:wm, :sizefrom, window, who)
      end
    end

    # The stackorder command returns a list of toplevel windows in stacking
    # order, from lowest to highest.
    # When a single toplevel window is passed, the returned list recursively
    # includes all of the window's children that are toplevels.
    # Only those toplevels that are currently mapped to the screen are returned.
    # The stackorder command can also be used to determine if one toplevel is
    # positioned above or below a second toplevel.
    # When two window arguments separated by either isabove or isbelow are
    # passed, a boolean result indicates whether or not the first window is
    # currently above or below the second window in the stacking order.
    def stackorder(window, order = None, other_window = None)
      if order == None || other_window == None
        Tk.execute(:wm, :stackorder, window)
      else
        Tk.execute_only(:wm, :stackorder, window, order, other_window)
      end
    end

    # If newstate is specified, the window will be set to the new state,
    # otherwise it returns the current state of window: either normal, iconic,
    # withdrawn, icon, or (Windows and Mac OS X only) zoomed.
    # The difference between iconic and icon is that iconic refers to a window
    # that has been iconified (e.g., with the wm iconify command) while icon
    # refers to a window whose only purpose is to serve as the icon for some
    # other window (via the wm iconwindow command).
    # The icon state cannot be set.
    def state(window, new_state = None)
      if new_state == None
        Tk.execute(:wm, :state, window)
      else
        Tk.execute_only(:wm, :state, window, new_state)
      end
    end

    # If string is specified, then it will be passed to the window manager for
    # use as the title for window (the window manager should display this string
    # in window's title bar).
    # In this case the command returns an empty string.
    # If string is not specified then the command returns the current title for
    # the window.
    # The title for a window defaults to its name.
    def title(window, string = None)
      if string == None
        Tk.execute(:wm, :title, window)
      else
        Tk.execute_only(:wm, :title, window, string)
      end
    end

    # If master is specified, then the window manager is informed that window is
    # a transient window (e.g.
    # pull-down menu) working on behalf of master (where master is the path name
    # for a top-level window).
    # If master is specified as an empty string then window is marked as not
    # being a transient window any more.
    # Otherwise the command returns the path name of window's current master, or
    # an empty string if window is not currently a transient window.
    # A transient window will mirror state changes in the master and inherit the
    # state of the master when initially mapped.
    # It is an error to attempt to make a window a transient of itself.
    def transient(window, master = None)
      Tk.execute(:wm, :transient, window, master)
    end

    # Arranges for window to be withdrawn from the screen.
    # This causes the window to be unmapped and forgotten about by the window
    # manager. If the window has never been mapped, then this command causes the
    # window to be mapped in the withdrawn state.
    # Not all window managers appear to know how to handle windows that are
    # mapped in the withdrawn state.
    # Note: it sometimes seems to be necessary to withdraw a window and then
    # re-map it (e.g.
    # with wm deiconify) to get some window managers to pay attention to changes
    # in window attributes such as group.
    def withdraw(window)
      Tk.execute(:wm, :withdraw, window)
    end
  end
end
