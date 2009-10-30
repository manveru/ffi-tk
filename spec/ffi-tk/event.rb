require_relative '../helper'

Tk.init

describe Tk::Event do
  it 'associates event with button and calls it' do
    entered = false

    button = Tk::Button.new('.')
    button.bind('Enter'){ entered = true; Tk.stop }
    button.pack
    Tk::Event.generate(button, 'Enter')

    Tk.interp.do_events_until{ entered }

    entered.should == true
  end
end