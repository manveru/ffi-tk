require_relative '../helper'

Tk.init

describe Tk::Event do
  it 'associates event with button and calls it' do
    entered = false

    entry = Tk::Entry.new('.')
    entry.bind('Key'){ entered = true; Tk.stop }
    entry.pack
    entry.focus

    Tk.interp.do_events_until{
      Tk::Event.generate(entry, 'KeyPress-a')
      entered
    }

    entered.should == true
  end
end