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

  # Values round-trip through Tcl as strings; the numeric readers coerce them.
  describe 'typed readers and comparison' do
    it 'coerces the stored string via to_i and to_f' do
      v = Tk::Variable.new('num_var', 42)
      v.to_i.should == 42
      v.to_f.should == 42.0
      v.to_s.should == '42'
    end

    it 'reads a boolean-ish value with to_boolean' do
      Tk::Variable.new('bool_var', true).to_boolean.should == true
      Tk::Variable.new('bool_var2', false).to_boolean.should == false
    end

    it 'compares by string value against another Variable and a String' do
      a = Tk::Variable.new('cmp_a', 'apple')
      b = Tk::Variable.new('cmp_b', 'banana')
      (a < b).should == true
      (b > a).should == true
      a.should == Tk::Variable.new('cmp_c', 'apple')
      (a == 'apple').should == true
    end
  end
end
