# frozen_string_literal: true

require_relative '../../helper'

Tk.init

describe Tk::Bindtags do
  @entry = Tk::Entry.new('.')
  @entry.pack # only placed widgets have bindtags?

  it 'lists bindtags of a widget' do
    Tk::Bindtags.bindtags(@entry).should == ['.entry0', 'Entry', '.', 'all']
  end

  it 'reverses bindtags of a widget' do
    tags = Tk::Bindtags.bindtags(@entry)
    Tk::Bindtags.bindtags(@entry, tags.reverse)
    Tk::Bindtags.bindtags(@entry).should == tags.reverse
  end

  it 'reads and rewrites bindtags through the Widget#bindtags delegator' do
    entry = Tk::Entry.new('.')
    entry.pack
    default = entry.bindtags
    default.should.include entry.tk_pathname

    entry.bindtags(default.reverse)
    entry.bindtags.should == default.reverse
  end

  describe 'Tk::BindTag' do
    it 'binds and unbinds a named tag and renders as a Tcl string' do
      tag = Tk::BindTag.new('MyClass')
      tag.to_tcl.to_s.should == 'MyClass'

      fired = []
      tag.bind('<<Custom>>') { |_e| fired << :hit }
      # the binding is registered against the tag name
      Tk.execute('bind', 'MyClass', '<<Custom>>').to_s.should =~ /RubyFFI::event/

      -> { tag.unbind('<<Custom>>') }.should.not.raise
      Tk.execute('bind', 'MyClass', '<<Custom>>').to_s.should == ''
    end
  end
end
