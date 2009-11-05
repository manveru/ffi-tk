require 'ffi-tk'

Tk.init

label = Tk::Label.new(Tk.root, text: 'Press any key to open the dialog')
label.pack

Tk.root.bind('<Key>'){
  answer = Tk.message_box(
    message: 'Really quit?',
    icon: :question,
    type: :yesno,
    detail: 'Select "Yes" to make the application exit')

  case answer
  when :yes
    exit
  when :no
    Tk.message_box(
      message: 'I know you like this application!',
      type: :ok)
    exit
  end
}

Tk.mainloop