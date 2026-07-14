# frozen_string_literal: true

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
    -> { Tk.text_relayout }.should.raise(NameError)
  end

  it 'switches to a different library path and back' do
    original = Tk.library
    Tk.library = '/tmp/some-other-tk-library'
    Tk.library.should == '/tmp/some-other-tk-library'
    Tk.library = original
    Tk.library.should == original
  end

  it 'reports the text_redraw debug variable once a text widget sets it' do
    t = Tk::Text.new
    t.pack
    t.debug(true)
    t.insert('1.0', "trigger a redraw\n")
    Tk.execute('update')
    # the variable exists and reads back (its exact contents are Tk-internal)
    -> { Tk.text_redraw }.should.not.raise
  end
end
