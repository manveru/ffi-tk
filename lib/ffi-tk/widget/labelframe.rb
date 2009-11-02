module Tk
  class LabelFrame
    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('labelframe', assign_pathname, options.to_tcl_options)
    end

    # Returns the current value of the configuration option given by option.
    # Option may have any of the values accepted by the labelframe command.
    def cget(option)
      execute(:cget, option)
    end

    # Query or modify the configuration options of the widget.
    # If no option is specified, returns a list describing all of the available
    # options for pathName (see Tk_ConfigureInfo for information on the format
    # of this list).
    # If option is specified with no value, then the command returns a list
    # describing the one named option (this list will be identical to the
    # corresponding sublist of the value returned if no option is specified).
    # If one or more option-value pairs are specified, then the command
    # modifies the given widget option(s) to have the given value(s); in this
    # case the command returns an empty string.
    # Option may have any of the values accepted by the labelframe command.
    # grid [labelframe .burger -text "Burger"] \ [labelframe .bun -text "Bun"]
    # -sticky news grid [labelframe .cheese -text "Cheese Option"] \
    # [labelframe .pickle -text "Pickle Option"] -sticky news foreach {type
    # name val} { burger Beef beef burger Lamb lamb burger Vegetarian beans bun
    # Plain white bun Sesame seeds bun Wholemeal brown cheese None none cheese
    # Cheddar cheddar cheese Edam edam cheese Brie brie cheese Gruy\u00e8re
    # gruyere cheese "Monterey Jack" jack pickle None none pickle Gherkins
    # gherkins pickle Onions onion pickle Chili chili } { set w [radiobutton
    # .$type.$val -text $name -anchor w \ -variable $type -value $val] pack $w
    # -side top -fill x } set burger beef set bun white set cheese none set
    # pickle none
    def configure(?option? ?value option value ...?)
      execute(:configure, ?option? ?value option value ...?)
    end
  end
end
