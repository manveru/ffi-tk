#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/ffi-tk'

Tk.init

Tk::Tile::Style.theme_use 'alt'

THEMELIST = [
  %w(default Default),
  %w(classic Classic),
  %w(alt Revitalized),
  %w(clam Clam),
  ['winnative', 'Windows native'],
  ['xpnative', 'XP Native'],
  %w(aqua Aqua)
].freeze
RUBY_THEMELIST = [].freeze
RUBY_THEMELIST << ['kroc-rb', 'Kroc (by Ruby)', false]

def makeThemeControl(parent)
  frame = Tk::Tile::LabelFrame.new parent, text: 'Theme'

  THEMELIST.each do |theme, name|
    b = Tk::Tile::RadioButton.new(frame, text: name, value: theme,
                                         command: proc { Tk::Tile::Style.theme_use(theme) })

    b.grid sticky: 'ew'
    b.state(:disabled) unless Tk::Tile::Style.theme_names.include?(theme)
  end
  RUBY_THEMELIST.each do |theme, name, available|
    b = Tk::Tile::RadioButton.new(frame, text: name, value: theme,
                                         command: proc { Tk::Tile::Style.theme_use(theme) })

    b.grid sticky: 'ew'
    b.state(:disabled) unless available # ? use #ttk_state
  end
  frame
end

makeThemeControl(Tk.root).pack side: 'left'

BUTTONS = %w(open new save).freeze
TOOLBARS = [].freeze
CHECKBOXES = %w(bold italic).freeze
ICON = {}.freeze

# def loadIcons(file)
#  Tk.load_tclscript(file)
#  img_data = TkVarAccess.new('ImgData')
#  img_data.keys.each{|icon|
#    $ICON[icon] = TkPhotoImage.new(:data=>img_data[icon])
#  }
# end
# loadIcons(File.join(demodir, 'iconlib.tcl'))

def makeToolbars(parent)
  #
  # Tile toolbar:
  #

  tb = Tk::Tile::Frame.new(parent, class: 'Toolbar')
  # tb = Tk::Tile::Frame.new(parent)
  TOOLBARS << tb
  i = 0
  BUTTONS.each do |icon|
    i += 1
    Tk::Tile::Button.new(tb, text: icon,
                             # :image=>$ICON[icon],
                             # :compound=>$V[:COMPOUND],
                             style: :Toolbutton).grid(row: 0, column: i,
                                                      sticky: :news)
  end
  CHECKBOXES.each do |icon|
    i += 1
    Tk::Tile::CheckButton.new(tb, text: icon,
                                  #:image=>$ICON[icon],
                                  #:variable=>$V.ref(icon),
                                  #:compound=>$V[:COMPOUND],
                                  style: :Toolbutton).grid(row: 0, column: i,
                                                           sticky: :news)
  end

  mb = Tk::Tile::MenuButton.new(tb, text: 'toolbar')
  #:image=>$ICON['file'],
  #:compound=>$V[:COMPOUND]
  mb.configure menu: makeCompoundMenu(mb)

  i += 1
  mb.grid(row: 0, column: i, sticky: :news)

  i += 1
  tb.grid_columnconfigure(i, weight: 1)

  tb
end

#
# Toolbar :compound control:
#
def makeCompoundMenu(mb)
  menu = Tk::Menu.new(mb)
  %w(text image none top bottom left right center).each do |str|
    # menu.add(:radiobutton, :label=> Tk.tk_call('string', 'totitle', str),
    menu.add(:radiobutton, label: str,
                           value: str,
                           #:variable=>$V.ref(:COMPOUND),
                           command: proc { puts 'foo'; true })
  end
  menu
end

makeToolbars(Tk.root)
# makeToolbars(Tk.root).pack
TOOLBARS.each(&:pack)

# puts Tk::Tile::Style.theme_names.inspect
Tk.mainloop
