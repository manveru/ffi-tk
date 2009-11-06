module Tk::Tile
  def self.style(style, parent_name)
    [style, parent_name.to_s.split('::').last].join('.')
  end

  module Style
    extend Tk::Cget, Tk::Configure
    TkkStyleCmd = 'ttk::style'.freeze

    # Returns a list of all known themes.
    def self.theme_names
      Tk.execute('ttk::style', 'theme', 'names')
    end

    # Sets the current theme to themeName, and refreshes all widgets.
    def self.theme_use(name)
      return unless theme_names.include? name
      Tk.execute_only('ttk::style', 'theme', 'use', name) && name
    end

    # Temporarily sets the current theme to themeName, evaluate script,
    # then restore the previous theme. Typically script simply defines
    # styles and elements, though arbitrary Tcl code may appear.
    def self.theme_settings(name, &block)
      return unless block
      raise ArgumentError unless theme_names.include? name

      id = Tk.uuid(:proc){|uuid| Tk.callbacks[uuid] = block }
      cmd = "{ RubyFFI::callback #{id} }"
      Tk.eval "ttk::style theme settings #{name} #{cmd}"
      #Tk.execute_only('ttk::style', 'theme', 'settings', name, cmd)
      Tk.callbacks.delete(id) if id
      name
    end

    # Creates a new theme. It is an error if themeName already exists.
    # If -parent is specified, the new theme will inherit styles, elements, and
    # layouts from the parent theme basedon. If -settings is present, script is
    # evaluated in the context of the new theme as per ttk::style theme settings.
    def self.theme_create(name, options={}, &block)
      raise ArgumentError if theme_names.include? name
      options = options.to_tcl_options

      if block
        id = Tk.uuid(:proc){|uuid| Tk.callbacks[uuid] = block }
        options << " -settings { RubyFFI::callback #{id} }"
      end
      res = Tk.execute_only('ttk::style', 'theme', 'create', name, options)
      Tk.callbacks.delete(id) if id
      res
    end


    # Returns the list of elements defined in the current theme.
    def self.element_names
      Tk.execute('ttk::style', 'element', 'names')
    end

    # Returns the list of element's options.
    def self.element_options(name)
      return unless element_names.include? name
      Tk.execute('ttk::style', 'element', 'options', name).to_a
    end

    # Creates a new element in the current theme of type type. The only
    # built-in element type is image (see ttk_image(n)), although themes
    # may define other element types (see Ttk_RegisterElementFactory).
    def self.element_create(name, type, args=nil, options={})
      if type == 'image' || type == :image
        Tk.execute_only('ttk::style', 'element', 'create', name, 'image', args, options.to_tcl_options)
      else
        #Tk.execute_only('ttk::style', 'element', 'create', name, type)
      end
    end


    # Define the widget layout for style style. See LAYOUTS below for the format
    # of layoutSpec. If layoutSpec is omitted, return the layout specification
    # for style style.
    def self.layout(name, layout_spec)
      Tk.execute_only('ttk::style', 'layout', name, layout_spec)
    end

    # Sets dynamic values of the specified option(s) in style.
    # Each statespec / value pair is examined in order; the value
    # corresponding to the first matching statespec is used.
    def self.map(style, options={})
      style.kind_of?(Hash) && (options, style = style, nil)
      style = '.' unless style

      Tk.execute_only('ttk::style', 'map', style, options.to_tcl_options )
    end

    # Sets the default value of the specified option(s) in style.
    def self.configure(style=nil, options={})
      style.kind_of?(Hash) && (keys, style = style, nil)
      style = '.' unless style

      Tk.execute_only('ttk::style','configure', style, options.to_tcl_options)
    end

    # Returns the value specified for -option in style style in state
    # state, using the standard lookup rules for element options.
    # state is a list of state names; if omitted, it defaults to all
    # bits off (the “normal” state). If the default argument is present,
    # it is used as a fallback value in case no specification
    # for -option is found.
    def self.lookup(style, option, state=Tk::None, default=Tk::None)
      Tk.execute('ttk::style', 'lookup', style, option.to_tcl_option, state, default).to_s
    end

  end
end
