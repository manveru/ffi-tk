# frozen_string_literal: true
require_relative '../../helper'

describe Tk::Tile::Treeview do
  it 'initializes' do
    instance = Tk::Tile::Treeview.new
    instance.class.should == Tk::Tile::Treeview
    instance.tk_parent.should == Tk.root
  end

  list = Tk::Tile::Treeview.new

  it 'shows configuration' do
    list.cget(:takefocus).should == false
    list.cget(:columns).should == []
    list.cget(:displaycolumns).should == ['#all']
    list.cget(:show).should == %w(tree headings)
    list.cget(:selectmode).should == :extended
    list.cget(:height).should == 10
    list.cget(:padding).should == []
    list.cget(:xscrollcommand).should.nil?
    list.cget(:yscrollcommand).should.nil?
    list.cget(:takefocus).should == false
    list.cget(:cursor).should.nil?
    list.cget(:style).should == []
    list.cget(:class).should.nil?
  end

  it 'returns the widget state' do
    list.ttk_state('active').should == true
  end

  it 'executes a block if the state matches the spec' do
    value = nil
    list.instate('active') { value = :active }
    value.should == :active
    list.instate('!active') { value = :inactive }
    value.should == :active
  end

  it 'creates a new item on root' do
    @item0 = list.insert(nil, 0, text: 'something')
    @item0.tk_parent.should == list
    @item0.id.should == 'I001'
  end

  it 'gets list of children' do
    list.children(nil).to_a.should == [@item0]
  end

  it 'returns options of the item' do
    @item0.options.should == {
      text: 'something',
      image: '',
      values: '',
      open: 0,
      tags: ''
    }
  end

  it 'returns options of a column' do
    list.column('#0').should == {
      width: 200,
      minwidth: 20,
      stretch: true,
      anchor: 'w',
      id: ''
    }
  end

  it 'knows the index of the item' do
    @item0.index.should == 0
  end

  it 'returns the bbox of the item' do
    @item0.bbox.should == []
  end

  it 'gets parent of item' do
    @item0.parent.should.nil?
  end

  it 'detaches the item' do
    @item0.detach
    @item0.should.exist
  end

  it 'deletes the item' do
    @item0.delete
    @item0.should.not.exist
  end

  it 'heading' do
    list.heading('#0').should == {
      text: '',
      image: '',
      anchor: 'center',
      command: '',
      state: ''
    }
  end
end
