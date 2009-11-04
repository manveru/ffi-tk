module Tk
  module Cget
    CGET_MAP = {}

    insert = lambda{|type, array|
      array.each{|option| CGET_MAP["-#{option}"] = type } }

    insert[:integer, %w[
      height width maxundo spacing1 spacing2 spacing3 borderwidth bd
      highlightthickness insertborderwidth insertofftime insertontime
      insertwidth padx pady selectborderwidth endline startline
    ]]
    insert[:boolean, %w[
      autoseparators blockcursor undo exportselection setgrid takefocus
    ]]
    insert[:color, %w[
      inactiveselectbackground disabledbackground disabledforeground background
      bg foreground fg highlightbackground highlightcolor insertbackground
      selectbackground selectforeground readonlybackground
    ]]
    insert[:command, %w[
      invalidcommand invcmd yscrollcommand xscrollcommand validatecommand
      command vcmd
    ]]
    insert[:string, %w[ tabs cursor text show ]]
    insert[:font, %w[ font ]]
    insert[:symbol, %w[ wrap state tabstyle relief justify validate ]]
    insert[:variable, %w[ textvariable ]]
    insert[:bitmap, %w[ stipple ]]

    def cget(option)
      option = option.to_tcl_option
      self.class.option_to_ruby(option, execute('cget', option))
    end

    module_function

    def option_to_ruby(name, value)
      if type = CGET_MAP[name.to_tcl_option]
        type_to_ruby(type, value)
      else
        raise "Unknown type for %p: %p" % [name, value]
      end
    end

    def type_to_ruby(type, value)
      case type
      when :integer
        value.to_i
      when :symbol
        value.to_sym?
      when :boolean
        Tk.boolean(value)
      when :color, :string, :font, :variable, :bitmap
        value.to_s?
      when :list
        value.to_a
      when :float
        value.to_f
      when :pathname
        Tk.pathname_to_widget(value.to_s)
      when :command
        string = value.to_s
        string unless string.empty?
      else
        raise "Unknown type: %p: %p" % [type, value]
      end
    end

    def option_hash_to_tcl(hash)
      result = {}

      hash.each do |key, value|
        case type = CGET_MAP[option = key.to_tcl_option]
        when :command
          command = register_command(key, &value)
          result[option] = command
        else
          result[option] = value
        end
      end

      result
    end
  end
end