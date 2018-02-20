# frozen_string_literal: true
require 'ffi-tk'

Tk.init

label = Tk::Label.new(Tk.root, text: 'Press any key to open the dialog')
label.pack

Tk.root.bind('<Key>') do
  dir = Tk.choose_color(initialcolor: 'grey', title: 'Choose a color')

  label.configure text: 'Press any key to close the window'

  if dir
    Tk::Label.new(Tk.root, text: "Selected #{dir}").pack
  else
    Tk::Label.new(Tk.root, text: 'No color selected').pack
  end

  Tk.root.bind('<Key>') { exit }
end

Tk.mainloop
