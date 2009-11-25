require_relative '../../helper'

Tk.init

describe Tk::Tile::Style do
  Style = Tk::Tile::Style

  it '#theme_names  returns a list of all known themes' do
    names = Style.theme_names

    names.should.kind_of? Array
    names.should.not.be.empty?
    names.all?{|i| i.kind_of?(String) }
    names.all?{|i| ["aqua", "clam", "alt", "default", "classic"].include? i }
    # tk-aqua: "aqua", "clam", ...
  end

  it '#theme_use  sets the current theme' do
    Style.theme_use('default').should == 'default'
    Style.theme_use('unkown-theme-').should.be.nil?
  end

  it '#element_names  returns the list of elements defined in the current theme' do
    names = Style.element_names

    names.should.kind_of? Array
    names.should.not.be.empty?
    names.all?{|i| i.kind_of?(String) }
    %w{label focus image text textarea}.each {|i| names.should.include? i }
  end

  it '#element_options  returns the list of elements options' do
    name = 'text'
    options = %w{-text -font -foreground -underline -width -anchor -justify -wraplength -embossed}

    Style.element_options(name).should.kind_of? Array
    Style.element_options(name).should.not.be.empty?
    Style.element_options(name).should == options

    Style.element_options('unkown-element').should == nil
  end

  it '#lookup  returns the value specified for -option in style style' do
    Style.lookup('label', 'font').should == 'TkDefaultFont'
    Style.lookup('label', 'foreground').should == 'black'
    Style.lookup('label', :foreground).should == 'black'
  end

  it '#configure  sets the default value of the specified option(s) in style' do
    # configure one element option
    Style.configure('label', foreground: 'gray' ).should == true
    Style.lookup('label', 'foreground').should == 'gray'

    # configure a hash of element options
    Style.configure('label', {foreground: 'gray', background: 'blue'} ).should == true
    Style.lookup('label', 'foreground').should == 'gray'
    Style.lookup('label', 'background').should == 'blue'

    Style.configure('label', foreground: 'black').should == true

    # configure other element..
    Style.configure('Button.label', foreground: :red ).should == true
    Style.lookup('Button.label', 'foreground').should == 'red'

    Style.configure('Button.label', foreground: :blue ).should == true
    Style.lookup('Button.label', 'foreground').should == 'blue'

    # element origin is still black
    Style.lookup('label', 'foreground').should == 'black'
  end

  it '#map  sets dynamic values of the specified option(s) in style' do
    Style.map('label', :background=>[:active, '#694418']).should == true
    Style.map(:foreground=>[:disabled, '#B2B2B2', :active, '#FFE7CB']).should == true
  end

  it '#layout  defines the widget layout for style' do
    Style.layout('TButton', [
      'Button.button', {:children=>[
        'Button.focus', {:children=>[
          'Button.padding', {:children=>[
            'Button.label', {:expand=>true, :sticky=>''}
          ]}
        ]}
      ]}
    ]).should == true

    module Tk::Tile::TScrollbar; end
    style_name = Tk::Tile.style('Vertical', Tk::Tile::TScrollbar)
    style_name.should == 'Vertical.TScrollbar'

    Style.layout(style_name, [
     'Checkbutton.background', # this is not needed in tile 0.5 or later
     'Checkbutton.border', {:children=>[
       'Checkbutton.padding', {:children=>[
         'Checkbutton.indicator', {:side=>:left},
         'Checkbutton.focus', {:side=>:left, :children=>[
           'Checkbutton.label'
         ]}
       ]}
     ]}
    ]).should == true
  end


  it '#element_create  creates a new element in the current theme' do
    Style.element_create('someElement','label').should == nil
    Style.element_names.should.not.include? "someElement"

    assets = {}
    assets['button-n'] = Tk::Image.create('photo').to_s
    assets['button-p'] = Tk::Image.create('photo').to_s
    assets['button-h'] = Tk::Image.create('photo').to_s

    Style.element_create('Button.button', :image,
                             [ assets['button-n'],
                               :pressed, assets['button-p'],
                               :active,  assets['button-h'],
                             ], :border=>3, :sticky=>:ew)

    Tk::Image.delete *assets.each_value
    Tk::Image.names.size.should == 0
  end

  it '#theme_settings  configure in the context of a theme' do

    res = Style.theme_settings 'alt' do
      Style.configure('label', foreground: :green ).should == true
      Style.lookup('label', 'foreground').should == 'green'
    end
    res.should == 'alt'

    # current theme stays untouched
    Style.lookup('label', 'foreground').should == 'black'
  end

  it '#theme_create  creates a new theme' do
    # Creates a new theme. It is an error if themeName already exists.
    lambda { Style.theme_create('default') }.should.raise ArgumentError

    #
    Style.theme_create('spec-theme').should == true
    Style.theme_names.should.include? 'spec-theme'

    # If -parent is specified, the new theme will inherit styles, elements, and
    # layouts from the parent theme basedon.
    Style.theme_create('spec-theme2', parent: 'default').should == true

    # If -settings is present, script is evaluated in the context of the new theme
    res = Style.theme_create('spec-theme-block', parent: 'default') do
      Style.configure('.', :background=>'#FCB64F',
                              :troughcolor=>'#F8C278', :borderwidth=>1)
      Style.configure(:font=>Tk::Tile::Font::Default, :borderwidth=>1)

      Style.map('.', :background=>[:active, '#694418'])
      Style.map(:foreground=>[:disabled, '#B2B2B2', :active, '#FFE7CB'])
    end
    res.should == true

  end

end
