require_relative '../../helper'

describe Tk::Tile::ComboBox do
  it 'initializes' do
    instance = Tk::Tile::ComboBox.new
    instance.class.should == Tk::Tile::ComboBox
    instance.tk_parent.should == Tk.root
  end

  it 'sets combobox values' do
    b = Tk::Tile::ComboBox.new Tk.root, values: ['a','b']
    b.configure(values: ['c','d']).should == true
  end

  it 'sets the current value' do
    var = Tk::Variable.new('somevar')
    var.set 'before_combobox'

    b = Tk::Tile::ComboBox.new Tk.root, textvariable: var, values: ['a','b']

    b.current.should == -1

    b.current(1).should == true
    b.current.should == 1

    var.to_s.should == 'b'

    b.set('baz').should == true
    var.to_s.should == 'baz'

    lambda { 
      b.current(10).should == false
    }.should.raise RuntimeError
  end

  it 'sets the value of the combobox to value' do
    b = Tk::Tile::ComboBox.new
    b.set(0).should == true
    b.set(1).should == true
  end

  it 'gets the current value of the combobox' do
    b = Tk::Tile::ComboBox.new
    b.get.should == ''

    b.set(1).should == true
    b.get.should == '1'

    b.set('baz').should == true
    b.get.should == 'baz'
  end

  it 'sets postcommand' do
    lambda { 
      Tk::Tile::ComboBox.new Tk.root, postcommand: proc {}
    }.should.not.raise RuntimeError

    lambda { 
      b = Tk::Tile::ComboBox.new
      b.postcommand { } 
    }.should.not.raise RuntimeError
  end

end

