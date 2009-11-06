module Tk::Tile
  class Dialog < Tk::Window
    include Tk::Configure, Tk::Cget
    include Tk::Tile::TileWidget

    #def initialize(parent, options = {}, &block)
    #  init_ttk_widget(parent, options, block, 'ttk::dialog')
    #end
    def initialize(parent, options = {}, &block)
      @parent = parent
      options[:command] = block if block
      style_spec = options.values_at(:style); options.delete(:style)

      #res = Tk.execute('ttk::dialog', assign_pathname, options.to_tcl_options)
      style(style_spec) if style_spec
      #res
      @options = options
    end

    def show
      Tk.execute('ttk::dialog', assign_pathname, @options.to_tcl_options)
    end

    def client_frame
      #window( Tk.execute('ttk::dialog::clientframe', @path))
    end


    def self.show(*args)
      dialog = self.new *args
      dialog.show
      [dialog.status, dialog.value]
    end

    def self.display(*args)
      show *args
    end
    def self.define_dialog_type(name, keys)
      Tk.execute_only('ttk::dialog::define', name, keys) && name
    end

  end
end

=begin
  def configinfo(slot = nil)
    if slot
      slot = slot.to_s
      [ slot, nil, nil, nil, @keys[slot] ]
    else
      @keys.collect{|k, v| [ k, nil, nil, nil, v ] }
    end
  end
=end

