require 'ffi-tk'

Tk.init

def change_palette(background)
  Tk.set_palette(background)
  @exception.configure(text: '')
rescue Exception => ex
  @exception.configure(text: ex.message)
end

desc = <<DESC
This example shows how Tk can calculate whole palettes from a given background color.
Simply fill the entry field with a color you would like.

For example: "black", "yellow", "#fafafa", or "#f00"

Hit Return to change the color.
DESC

Tk::Label.new(Tk.root, text: desc).pack

@exception = Tk::Label.new(Tk.root).pack
@entry = Tk::Entry.new(Tk.root).pack
@entry.bind('<Return>'){
  change_palette(@entry.get)
  @entry.delete(0, :end)
}

Tk::Button.new(Tk.root, text: 'Exit'){ exit }.pack

Tk.mainloop