# frozen_string_literal: true

require_relative '../../helper'

describe Tk::MenuButton do
  it 'initializes' do
    instance = Tk::MenuButton.new
    instance.class.should == Tk::MenuButton
    instance.tk_parent.should == Tk.root
  end

  it 'round-trips -menu as the associated menu widget, nil when unset' do
    mb = Tk::MenuButton.new
    mb.cget(:menu).should.nil?

    menu = Tk::Menu.new(mb)
    mb.configure(menu: menu)
    mb.cget(:menu).should == menu
    mb.destroy
  end
end
