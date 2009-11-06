require 'ffi-tk'

Tk.init

label = Tk::Label.new(Tk.root, text: 'Here will be the value of button displayed')
label.pack

var = Tk.option_menu('.foo', 'Yes', 'Of course', 'Maybe', 'Maybe not', 'No', 'Never')
Tk::Pack.pack('.foo')
Tk::Bind.bind('.foo', '<Configure>'){ label.configure(text: var.get) }
var.set 'Maybe' # initial option

label.configure text: var.get

Tk::Button.new(Tk.root, text: 'Exit'){ exit }.pack

Tk.mainloop