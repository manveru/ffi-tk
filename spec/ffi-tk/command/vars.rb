require_relative '../../helper'

Tk.init

describe 'tkvars' do
  it 'has a library set' do
    library = Tk.library
    library.class.should == String
    library.should.not.be.empty
  end

  it 'has a patchlevel' do
    Tk.patchlevel.should =~ /\A(\d+)\.(\d+)\.(\d+)\Z/
  end

  it 'has a version' do
    Tk.version.should =~ /\A(\d+)\.(\d+)\Z/
  end

  it 'is not set to strict motif' do
    Tk.strict_motif.should.be.false
  end

  it 'sets to strict motif' do
    Tk.strict_motif = true
    Tk.strict_motif.should.be.true
  end

  it 'does not have text_relayout set' do
    lambda{ Tk.text_relayout }.should.raise(NameError)
  end
end