require 'ffi-tk'

Tk.init

label = Tk::Label.new(Tk.root, text: 'Press any key to open the dialog')
label.pack

Tk.root.bind('<Key>'){
  dir = Tk.choose_directory(initialdir: '~', title: 'Choose a directory')

  label.configure text: 'Press any key to close the window'

  if dir
    Tk::Label.new(Tk.root, text: "Selected #{dir}").pack
  else
    Tk::Label.new(Tk.root, text: 'No directory selected').pack
  end

  Tk.root.bind('<Key>'){ exit }
}

Tk.mainloop