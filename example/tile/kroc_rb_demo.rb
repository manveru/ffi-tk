#
# based on:
#   >> kroc.rb - by Hidetoshi NAGAI (nagai@ai.kyutech.ac.jp)
#   >> kroc.tcl - Copyright (C) 2004 David Zolli <kroc@kroc.tk>
#

#NOTE not ready, needs photoimage and load_images
# * some parts are used in Tile::Style specs and work as excepted

#imgdir = File.join(File.dirname(__FILE__), 'kroc', 'kroc')
#$images = Tk::Tile.load_images(imgdir, '*.gif')

def kroc_rb_settings
  Tk::Tile::Style.configure('.', :background=>'#FCB64F',
                          :troughcolor=>'#F8C278', :borderwidth=>1)


  Tk::Tile::Style.configure('.', :font=>Tk::Tile::Font::Default, :borderwidth=>1)
  Tk::Tile::Style.configure(:font=>Tk::Tile::Font::Default, :borderwidth=>1)


  Tk::Tile::Style.map('.', :background=>[:active, '#694418'])
  Tk::Tile::Style.map(:foreground=>[:disabled, '#B2B2B2', :active, '#FFE7CB'])


  Tk::Tile::Style.configure('TButton', :padding=>[10,4])

  Tk::Tile::Style.configure('TNotebook.Tab',
                          :padding=>[10, 3], :font=>Tk::Tile::Font::Default)

  Tk::Tile::Style.map('TNotebook.Tab',
                      :background=>[:selected, '#FCB64F', '', '#FFE6BA'],
                      :foreground=>['', 'black'],
                      :padding=>[:selected, [10, 6, 10, 3]])

  # Tk::Tile::Style.map('TScrollbar',
  Tk::Tile::Style.map(Tk::Tile::TScrollbar,
                      :background=>[:pressed, '#694418'],
                      :arrowcolor=>[:pressed, '#FEF7CB'],
                      :relief=>[:pressed, :sunken])

  # Tk::Tile::Style.layout('Vertical.TScrollbar',
  Tk::Tile::Style.layout(Tk::Tile.style('Vertical', Tk::Tile::TScrollbar),
                         ['Scrollbar.trough', {:children=>[
                             'Scrollbar.uparrow',   {:side=>:top},
                             'Scrollbar.downarrow', {:side=>:bottom},
                             'Scrollbar.uparrow',   {:side=>:bottom},
                             'Scrollbar.thumb',  {:side=>:top, :expand=>true}
                           ]}
                         ])

  # Tk::Tile::Style.layout('Horizontal.TScrollbar',
  Tk::Tile::Style.layout(Tk::Tile.style('Horizontal', Tk::Tile::TScrollbar),
                         ['Scrollbar.trough', {:children=>[
                             'Scrollbar.leftarrow',   {:side=>:left},
                             'Scrollbar.rightarrow', {:side=>:right},
                             'Scrollbar.leftarrow',   {:side=>:right},
                             'Scrollbar.thumb',  {:side=>:left, :expand=>true}
                           ]}
                         ])

  #
  # Elements:
  #
  Tk::Tile::Style.element_create('Button.button',
                                 :image,
                                 [ $images['button-n'],
                                   :pressed, $images['button-p'],
                                   :active,  $images['button-h'],
                                 ], :border=>3, :sticky=>:ew)

  Tk::Tile::Style.element_create('Checkbutton.indicator',
                                 :image,
                                 [ $images['check-nu'],
                                   [:pressed, :selected],$images['check-nc'],
                                   :pressed,             $images['check-nu'],
                                   [:active, :selected], $images['check-hc'],
                                   :active,              $images['check-hu'],
                                   :selected,            $images['check-nc'],
                                 ], :sticky=>:w)

  Tk::Tile::Style.element_create('Radiobutton.indicator',
                                 :image,
                                 [ $images['radio-nu'],
                                   [:pressed,:selected],$images['radio-nc'],
                                   :pressed,            $images['radio-nu'],
                                   [:active,:selected], $images['radio-hc'],
                                   :active,             $images['radio-hu'],
                                   :selected,           $images['radio-nc'],
                                 ], :sticky=>:w)


  #
  # Settings:
  #
  # Tk::Tile::Style.layout(Tk::Tile::TButton,
  Tk::Tile::Style.layout('TButton', [
      'Button.button', {:children=>[
           'Button.focus', {:children=>[
                'Button.padding', {:children=>[
                    'Button.label', {:expand=>true, :sticky=>''}
                ]}
           ]}
      ]}
  ])

  # Tk::Tile::Style.layout(Tk::Tile::TCheckbutton,
  Tk::Tile::Style.layout('TCheckbutton', [
      'Checkbutton.background', # this is not needed in tile 0.5 or later
      'Checkbutton.border', {:children=>[
           'Checkbutton.padding', {:children=>[
                'Checkbutton.indicator', {:side=>:left},
                'Checkbutton.focus', {:side=>:left, :children=>[
                    'Checkbutton.label'
                ]}
           ]}
      ]}
  ])

  # Tk::Tile::Style.layout(Tk::Tile::TRadiobutton,
  Tk::Tile::Style.layout('TRadiobutton', [
      'Radiobutton.background', # this is not needed in tile 0.5 or later
      'Radiobutton.border', {:children=>[
           'Radiobutton.padding', {:children=>[
                'Radiobutton.indicator', {:side=>:left},
                'Radiobutton.focus', {:expand=>true, :sticky=>:w, :children=>[
                    'Radiobutton.label', {:side=>:right, :expand=>true}
                ]}
           ]}
      ]}
  ])
end

Tk::Tile::Style.theme_create( 'kroc-rb', parent: 'alt', settings: proc{ kroc_rb_settings() } )

