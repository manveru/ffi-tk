# frozen_string_literal: true
require_relative '../helper'

Tk.init

describe Tk::Variable do
  it 'creates a Variable' do
    @var = Tk::Variable.new('somevar')
    @var.name.should == 'somevar'
  end

  it 'cannot get a value from it yet' do
    -> { @var.get }.should.raise(NameError)
  end

  it 'sets the value and retrieves it' do
    @var.set('Hello, World!')
    @var.to_s.should == 'Hello, World!'
  end

  it 'unsets the variable' do
    @var.unset
    -> { @var.get }.should.raise(NameError)
  end
end
