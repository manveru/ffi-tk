# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Button do
  it 'handles -command' do
    ran = false
    Tk.callbacks.size.should == 0

    button = Tk::Button.new do
      ran = true
      button.destroy
    end
    button.invoke

    Tk.callbacks.size.should == 0
    ran.should == true
  end

  it 'sets the text of the button' do
    button = Tk::Button.new(text: 'Hello, World!')
    button.cget(:text).should == 'Hello, World!'
  end

  it 'returns the command result from invoke' do
    button = Tk::Button.new { [:clicked, 1] }
    button.invoke.should == ['clicked', 1]
    button.destroy

    plain = Tk::Button.new(text: 'no command')
    plain.invoke.should.nil?
    plain.destroy
  end
end
