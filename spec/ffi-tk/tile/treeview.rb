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
    list.cget(:takefocus).should == 'ttk::takefocus'
    list.cget(:columns).should == []
    list.cget(:displaycolumns).should == ['#all']
    list.cget(:show).should == %w[tree headings]
    list.cget(:selectmode).should == :extended
    list.cget(:height).should == 10
    list.cget(:padding).should == []
    list.cget(:xscrollcommand).should.nil?
    list.cget(:yscrollcommand).should.nil?
    list.cget(:takefocus).should == 'ttk::takefocus'
    list.cget(:cursor).should == ''
    list.cget(:style).should == ''
    list.cget(:class).should == ''
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
      values: [],
      open: false,
      tags: []
    }
  end

  it 'returns options of a column' do
    list.column('#0').should == {
      width: 200,
      minwidth: 20,
      stretch: true,
      anchor: :w,
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
      anchor: :center,
      command: nil,
      state: []
    }
  end
end

# Self-contained coverage for the Treeview + Item methods not exercised above.
# Each spec builds its own populated tree so ordering never couples them.
describe 'Tk::Tile::Treeview coverage' do
  # Build a placed treeview with +columns+ and rows [text, *values].
  def build(columns: [], rows: [])
    tv = Tk::Tile::Treeview.new
    tv.configure(columns: columns) unless columns.empty?
    tv.place(width: 240, height: 160)
    items = rows.map do |(text, *values)|
      tv.insert(nil, :end, text: text, values: values)
    end
    [tv, items]
  end

  it 'sets, adds, removes and toggles the selection (multi-item list)' do
    tv, (a, b, c) = build(rows: [['a'], ['b'], ['c']])

    tv.selection.should == []

    tv.selection_set(a, b)
    tv.selection.map(&:id).should == [a.id, b.id]

    tv.selection_add(c)
    tv.selection.map(&:id).should == [a.id, b.id, c.id]

    tv.selection_remove(a)
    tv.selection.map(&:id).should == [b.id, c.id]

    tv.selection_toggle(b)
    tv.selection.map(&:id).should == [c.id]
  end

  it 'selects and deselects through Item helpers' do
    tv, (a, b) = build(rows: [['a'], ['b']])

    a.selection_set
    tv.selection.map(&:id).should == [a.id]

    b.select # alias for selection_add
    tv.selection.map(&:id).should == [a.id, b.id]

    a.deselect # alias for selection_remove
    tv.selection.map(&:id).should == [b.id]

    b.toggle # alias for selection_toggle
    tv.selection.should == []
  end

  it 'reads and writes cell values by column' do
    tv, (a,) = build(columns: %i[size owner], rows: [%w[a 10 root]])

    tv.set(a, :size).should == '10'
    tv.set(a).should == %w[size 10 owner root]

    tv.set(a, :size, 99)
    tv.set(a, :size).should == '99'
    tv.item(a, :values).should == %w[99 root]

    a.set(:owner, 'admin')
    a.set(:owner).should == 'admin'
    a.set.should == %w[size 99 owner admin]
  end

  it 'configures tags and reads options back individually or as a hash' do
    tv, = build(rows: [['a']])

    tv.tag_configure(:hot, foreground: 'red')
    tv.tag_configure(:hot, :foreground).should == 'red'
    tv.tag_configure(:hot)[:foreground].should == 'red'

    # An undefined tag yields the full option hash; an empty :color coerces to
    # nil (no colour bound), per the empty-value rule.
    tv.tag_configure(:cold)[:foreground].should.nil?
  end

  it 'binds a tag event through the RubyFFI event trampoline' do
    tv, = build(rows: [['a']])
    tv.tag_bind('hot', '<Button-1>') { |_e| }

    # Querying the bound script must reveal the real ::RubyFFI::event trampoline
    # (which delivers event data), not a bare callback with no substitutions.
    tv.tag_bind('hot', '<Button-1>').to_s.should =~ /RubyFFI::event/
  end

  it 'moves an item to a new parent and index' do
    tv, (a, b) = build(rows: [['a'], ['b']])
    child = tv.insert(a.id, :end, text: 'child')

    tv.parent(child).id.should == a.id

    tv.move(child, nil, :end)
    tv.parent(child).should.nil?
    tv.children(nil).map(&:id).should == [a.id, b.id, child.id]

    child.move(b.id, 0) # Item#move delegates to Treeview#move
    tv.parent(child).id.should == b.id
  end

  it 'reattaches a detached item via move' do
    tv, (a, b, c) = build(rows: [['a'], ['b'], ['c']])

    tv.detach(b)
    tv.children(nil).map(&:id).should == [a.id, c.id]
    tv.exists(b).should == true # detached, not deleted

    tv.move(b, nil, 0)
    tv.children(nil).map(&:id).should == [b.id, a.id, c.id]
    tv.index(b).should == 0
  end

  it 'navigates prev and next siblings' do
    tv, (a, b, c) = build(rows: [['a'], ['b'], ['c']])

    tv.next(a).id.should == b.id
    tv.prev(c).id.should == b.id
    a.next.id.should == b.id
    c.prev.id.should == b.id

    tv.next(c).should.nil?  # last child has no next sibling
    tv.prev(a).should.nil?  # first child has no prev sibling
  end

  it 'sets and reports the focus item' do
    tv, (a, b) = build(rows: [['a'], ['b']])

    tv.focus_item(b)
    tv.focus_item.id.should == b.id

    a.focus # Item#focus
    tv.focus_item.id.should == a.id
  end

  it 'reports whether items exist' do
    tv, (a,) = build(rows: [['a']])

    tv.exists(a).should == true
    a.exist?.should == true

    a.delete
    tv.exists(a).should == false
    a.exist?.should == false
  end

  it 'sees an item, opening its ancestors' do
    tv, (a,) = build(rows: [['a']])
    child = tv.insert(a.id, :end, text: 'child')

    tv.item(a, :open).should == false
    tv.see(child)
    tv.item(a, :open).should == true
  end

  it 'scrolls via the Scrollable xview/yview mixed into treeview' do
    tv, = build(columns: %i[size], rows: (0..30).map { |i| ["row#{i}", i.to_s] })

    xview = tv.xview
    yview = tv.yview
    [xview, yview].each do |view|
      view.size.should == 2
      view.all? { |f| f.is_a?(Float) && f.between?(0.0, 1.0) }.should == true
      view.first.should <= view.last
    end

    # Query is a no-op on position; scrolling down moves the top fraction.
    top_before = tv.yview.first
    tv.yview_moveto(0.5)
    tv.yview.first.should > top_before
  end

  it 'identifies the row and column under a point' do
    tv, (a,) = build(columns: %i[size], rows: [%w[a 1]])
    next unless skip_unless_mapped(tv)

    box = tv.bbox(a)
    box.size.should == 4 # x y width height for the visible row
    x = box[0].to_i + 2
    y = box[1].to_i + 2

    tv.identify_row(x, y).should == a.id
    tv.identify_column(x, y).should == '#0' # the tree column
  end
end
