# frozen_string_literal: true

require_relative '../../helper'

# Bell is fire-and-forget: it produces no observable Tcl result beyond success,
# so these specs exercise the option-building paths and confirm each returns.
describe Tk::Bell do
  it 'rings the bell' do
    Tk::Bell.bell.should == true
  end

  it 'accepts the nice option' do
    Tk::Bell.bell(nice: true).should == true
  end

  it 'accepts an explicit displayof' do
    Tk::Bell.bell(displayof: '.').should == true
  end

  it 'rings on the widget itself through the Widget#bell delegator' do
    Tk::Button.new('.', text: 'ring').bell.should == true
  end
end
