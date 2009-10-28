#!/usr/bin/env ruby

require_relative '../lib/ffi-tk'

Tk.init

text = Tk::Text.new('.')
text.insert :end, 'Hello, World!'
text.pack
p text.bbox '0.1'
p text.index 'end'

%w[ autoseparators autoseparators blockcursor endline inactiveselectbackground
maxundo spacing1 spacing2 spacing3 startline state tabs tabstyle undo width wrap

background bg
borderwidth bd
cursor
exportselection
font
foreground
fg
highlightbackground
highlightcolor
highlightthickness
insertbackground
insertborderwidth
insertofftime
insertontime
insertwidth
padx
pady
relief
selectbackground
selectborderwidth
selectforeground
setgrid
takefocus
xscrollcommand
yscrollcommand
].each do |option|
  p option: text.cget(option)
end

Tk.root.bind('Control-q'){ exit }

Tk.mainloop