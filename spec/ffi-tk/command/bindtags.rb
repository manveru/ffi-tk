require_relative '../../helper'

Tk.init

describe Tk::Bindtags do
  @entry = Tk::Entry.new('.')
  @entry.pack # only placed widgets have bindtags?

  it 'lists bindtags of a widget' do
    Tk::Bindtags.bindtags(@entry).should == [".entry0", "Entry", ".", "all"]
  end

  it 'reverses bindtags of a widget' do
    tags = Tk::Bindtags.bindtags(@entry)
    Tk::Bindtags.bindtags(@entry, tags.reverse)
    Tk::Bindtags.bindtags(@entry).should == tags.reverse
  end
end
