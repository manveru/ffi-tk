# frozen_string_literal: true
require 'ffi-tk'

Tk.init

label = Tk::Label.new(Tk.root, text: 'Press any key to open the dialog')
label.pack

Tk.root.bind('<Key>') do
  question = 'Do you love ruby?'
  answers = ['Yes', 'No', "I'm not sure"]
  reply =
    Tk.dialog('.foo', 'Love is all around', question, 'questhead', 0, *answers)

  label.configure text: 'Press any key to close the window'

  text =
    case reply
    when 0
      'Of course you do!'
    when 1
      'Your loss'
    when 2
      Tk::Button.new(Tk.root, text: 'Show source') do
        text = Tk::Text.new(Tk.root)
        text.insert :end, File.read(__FILE__)
        text.pack
      end.pack

      "If you haven't fallen in love yet, take a look at my source."
    end

  Tk::Label.new(Tk.root, text: text).pack

  Tk.root.bind('<Key>') { exit }
end

Tk.mainloop
