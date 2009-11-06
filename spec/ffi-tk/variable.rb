require_relative '../helper'

Tk.init

describe Tk::Variable do
  it 'creates a Variable' do
    @var = Tk::Variable.new('somevar')
    @var.name.should == "$somevar"
  end

  it 'cannot get a value from it yet' do
    lambda{ @var.get }.should.raise(NameError)
  end

  it 'sets the value and retrieves it' do
    @var.set('Hello, World!')
    @var.get.should == 'Hello, World!'
  end

  it 'unsets the variable' do
    @var.unset
    lambda{ @var.get }.should.raise(NameError)
  end
end