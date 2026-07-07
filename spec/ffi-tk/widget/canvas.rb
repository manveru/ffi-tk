# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Canvas do
  it 'creates a canvas' do
    @canvas = Tk::Canvas.new
    @canvas.tk_pathname.should == '.canvas0'
    @canvas.pack fill: :both, expand: true
  end

  it 'creates text' do
    @text = @canvas.create_text(0, 0, text: 'Hello, World!')
    @text.id.should == 1
    @text.canvas.should == @canvas

    @text.activefill.should.nil?
    @text.activestipple.should.nil?
    @text.anchor.should == 'center'
    @text.disabledfill.should.nil?
    @text.disabledstipple.should.nil?
    ['black', '#000000'].should.include @text.fill
    @text.font.should == 'TkDefaultFont'
    @text.justify.should == :left
    @text.state.should.nil?
    @text.stipple.should.nil?
    @text.tags.should == []
    @text.text.should == 'Hello, World!'
    @text.underline.should == -1
    @text.width.should == 0
  end

  it 'creates a rectangle' do
    @rect = @canvas.create_rectangle(10, 11, 12, 13)
    @rect.id.should == 2
    @rect.canvas.should == @canvas

    @rect.dash.should == 0
    @rect.activedash.should == 0
    @rect.disableddash.should == 0
    @rect.dashoffset.should == 0
    @rect.fill.should.nil?
    @rect.activefill.should.nil?
    @rect.disabledfill.should.nil?
    @rect.offset.should == '0,0'
    ['black', '#000000'].should.include @rect.outline
    @rect.activeoutline.should.nil?
    @rect.disabledoutline.should.nil?
    @rect.outlineoffset.should == 0
    @rect.outlinestipple.should.nil?
    @rect.activeoutlinestipple.should.nil?
    @rect.disabledoutlinestipple.should.nil?
    @rect.stipple.should.nil?
    @rect.activestipple.should.nil?
    @rect.disabledstipple.should.nil?
    @rect.state.should.nil?
    @rect.tags.should == []
    @rect.width.should == 1
    @rect.activewidth.should == 0
    @rect.disabledwidth.should == 0
  end

  it 'creates an arc' do
    @arc = @canvas.create_arc(20, 21, 22, 23)
    @arc.id.should == 3
    @arc.canvas.should == @canvas

    @arc.dash.should == 0
    @arc.activedash.should == 0
    @arc.disableddash.should == 0
    @arc.dashoffset.should == 0
    @arc.fill.should.nil?
    @arc.activefill.should.nil?
    @arc.disabledfill.should.nil?
    @arc.offset.should == '0,0'
    ['black', '#000000'].should.include @arc.outline
    @arc.activeoutline.should.nil?
    @arc.disabledoutline.should.nil?
    @arc.outlineoffset.should == 0.0
    @arc.outlinestipple.should.nil?
    @arc.activeoutlinestipple.should.nil?
    @arc.disabledoutlinestipple.should.nil?
    @arc.stipple.should.nil?
    @arc.activestipple.should.nil?
    @arc.disabledstipple.should.nil?
    @arc.state.should.nil?
    @arc.tags.should == []
    @arc.width.should == 1
    @arc.activewidth.should == 0
    @arc.disabledwidth.should == 0
    @arc.extent.should == 90.0
    @arc.start.should == 0
    @arc.style.should == :pieslice
  end

  it 'creates a polygon' do
    @poly = @canvas.create_polygon(50, 50, 60, 60, 70, 70, 80, 70, 90, 60, 100, 50)
    @poly.id.should == 4
    @poly.canvas.should == @canvas

    @poly.dash.should == 0
    @poly.activedash.should == 0
    @poly.disableddash.should == 0
    @poly.dashoffset.should == 0
    ['black', '#000000'].should.include @poly.fill
    @poly.activefill.should.nil?
    @poly.disabledfill.should.nil?
    @poly.offset.should == '0,0'
    @poly.outline.should.nil?
    @poly.activeoutline.should.nil?
    @poly.disabledoutline.should.nil?
    @poly.outlinestipple.should.nil?
    @poly.activeoutlinestipple.should.nil?
    @poly.disabledoutlinestipple.should.nil?
    @poly.stipple.should.nil?
    @poly.activestipple.should.nil?
    @poly.disabledstipple.should.nil?
    @poly.state.should.nil?
    @poly.tags.should == []
    @poly.width.should == 1
    @poly.activewidth.should == 0
    @poly.disabledwidth.should == 0
    @poly.joinstyle.should == :round
    @poly.smooth.should == false
    @poly.splinesteps.should == 12
  end

  it 'creates a line' do
    @line = @canvas.create_line(10, 15, 20, 25)
    @line.id.should == 5
    @line.canvas.should == @canvas

    @line.dash.should == 0
    @line.activedash.should == 0
    @line.disableddash.should == 0
    @line.dashoffset.should == 0
    ['black', '#000000'].should.include @line.fill
    @line.activefill.should.nil?
    @line.disabledfill.should.nil?
    @line.stipple.should.nil?
    @line.activestipple.should.nil?
    @line.disabledstipple.should.nil?
    @line.state.should.nil?
    @line.tags.should == []
    @line.width.should == 1
    @line.activewidth.should == 0
    @line.disabledwidth.should == 0
    @line.arrow.should == :none
    @line.arrowshape.should == %w[8 10 3]
    @line.capstyle.should == :butt
    @line.joinstyle.should == :round
    @line.smooth.should == false
    @line.splinesteps.should == 12
  end

  it 'creates a window' do
    entry = Tk::Entry.new(Tk.root)
    @win = @canvas.create_window(10, 10, window: entry)
    @win.id.should == 6
    @win.canvas.should == @canvas

    @win.state.should.nil?
    @win.tags.should == []
    @win.anchor.should == 'center'
    @win.height.should == 0
    @win.width.should == 0
    @win.window.should == entry
  end

  # A freshly built, packed, updated canvas isolated from the shared @canvas so
  # item ids and the display list are predictable within a single spec.
  def fresh_canvas(width = 200, height = 200)
    cv = Tk::Canvas.new
    cv.configure(width: width, height: height)
    cv.pack
    Tk.update
    cv
  end

  it 'queries and sets coords' do
    cv = fresh_canvas
    rect = cv.create_rectangle(10, 10, 50, 50)
    cv.coords(rect).should == [10.0, 10.0, 50.0, 50.0]

    cv.coords(rect, 20, 20, 60, 60)
    cv.coords(rect).should == [20.0, 20.0, 60.0, 60.0]
  end

  it 'moves items by a delta' do
    cv = fresh_canvas
    rect = cv.create_rectangle(10, 10, 50, 50)
    cv.move(rect, 5, 7)
    cv.coords(rect).should == [15.0, 17.0, 55.0, 57.0]
  end

  it 'scales items about an origin' do
    cv = fresh_canvas
    rect = cv.create_rectangle(10, 10, 50, 50)
    cv.scale(rect, 0, 0, 2, 3)
    cv.coords(rect).should == [20.0, 30.0, 100.0, 150.0]
  end

  it 'adds and deletes tags with addtag_withtag/dtag' do
    cv = fresh_canvas
    rect = cv.create_rectangle(10, 10, 50, 50)
    cv.gettags(rect).should == []

    cv.addtag_withtag('marked', rect)
    cv.gettags(rect).should == ['marked']
    cv.find_withtag('marked').should == [rect.id]

    cv.dtag(rect, 'marked')
    cv.gettags(rect).should == []
  end

  it 'tags every item with addtag_all' do
    cv = fresh_canvas
    a = cv.create_rectangle(0, 0, 10, 10)
    b = cv.create_oval(20, 20, 30, 30)
    cv.addtag_all('everything')
    cv.find_withtag('everything').sort.should == [a.id, b.id].sort
  end

  it 'tags items by spatial relation' do
    cv = fresh_canvas
    inner = cv.create_rectangle(10, 10, 40, 40)
    outer = cv.create_rectangle(100, 100, 150, 150)

    cv.addtag_enclosed('enc', 0, 0, 60, 60)
    cv.find_withtag('enc').should == [inner.id]

    cv.addtag_overlapping('ov', 0, 0, 20, 20)
    cv.find_withtag('ov').should == [inner.id]

    cv.addtag_closest('near', 12, 12)
    cv.find_withtag('near').should == [inner.id]

    cv.addtag_above('stacked', inner)
    cv.gettags(outer).should == ['stacked']

    cv.addtag_below('lower', outer)
    cv.gettags(inner).should.include 'lower'
  end

  it 'finds items with find variants' do
    cv = fresh_canvas
    low = cv.create_rectangle(10, 10, 40, 40)
    high = cv.create_rectangle(100, 100, 150, 150)

    cv.find_all.sort.should == [low.id, high.id].sort
    cv.find_closest(12, 12).should == [low.id]
    cv.find_enclosed(0, 0, 60, 60).should == [low.id]
    cv.find_overlapping(0, 0, 20, 20).should == [low.id]
    cv.find_above(low).should == [high.id]
    cv.find_below(high).should == [low.id]
    cv.find_withtag(low).should == [low.id]
  end

  it 'reports an integer bounding box' do
    cv = fresh_canvas
    rect = cv.create_rectangle(10, 10, 50, 50)
    box = cv.bbox(rect)
    box.length.should == 4
    box.all? { |n| n.is_a?(Integer) }.should == true
    # Tk overestimates by ~1px; the box brackets the requested rectangle.
    box[0].should <= 10
    box[1].should <= 10
    box[2].should >= 50
    box[3].should >= 50
    cv.bbox('no-such-tag').should.nil?
  end

  it 'converts window to canvas coordinates' do
    cv = fresh_canvas
    cv.canvasx(17).should == 17.0
    cv.canvasy(23).should == 23.0
    # gridspacing rounds to the nearest multiple.
    cv.canvasx(17, 10).should == 20.0
    cv.canvasy(23, 10).should == 20.0
  end

  it 'reports the item type as a symbol' do
    cv = fresh_canvas
    cv.type(cv.create_rectangle(0, 0, 10, 10)).should == :rectangle
    cv.type(cv.create_oval(0, 0, 10, 10)).should == :oval
    cv.type(cv.create_text(0, 0, text: 'x')).should == :text
    cv.type('missing').should.nil?
  end

  it 'coerces its widget-level options by declared type' do
    cv = fresh_canvas
    cv.configure(closeenough: 2.5, confine: false, state: :disabled,
                 xscrollincrement: 10, yscrollincrement: 12,
                 scrollregion: [0, 0, 400, 300])

    cv.cget(:closeenough).should == 2.5     # :float
    cv.cget(:confine).should == false       # :boolean
    cv.cget(:state).should == :disabled     # :symbol (keyword set)
    # screen distances stay lossless as strings, never converted to pixels.
    cv.cget(:xscrollincrement).should == '10'
    cv.cget(:yscrollincrement).should == '12'
    cv.cget(:width).should == '200'
    cv.cget(:height).should == '200'
    # -scrollregion is a coordinate list (:list); elements stay strings.
    cv.cget(:scrollregion).should == %w[0 0 400 300]
  end

  it 'configure(option) returns that option\'s OptionDescription' do
    cv = fresh_canvas
    cv.configure(confine: false)
    description = cv.configure(:confine)
    description.should.be.is_a? Tk::OptionDescription
    description.name.should == :confine
    description.value.should == false
  end

  it 'round-trips options via itemconfigure/itemcget' do
    cv = fresh_canvas
    rect = cv.create_rectangle(0, 0, 10, 10)
    cv.itemconfigure(rect, fill: 'red', width: 3)
    ['red', '#ff0000'].should.include cv.itemcget(rect, :fill)
    # The typed accessor coerces the raw "3.0" itemcget value to an Integer.
    rect.width.should == 3

    # Per-item configure stays on the legacy value-returning path (item options
    # are a later phase): a single-option query extracts the current value from
    # canvas's string-typed describe-tuple, distinct from the widget-level
    # configure above which now returns typed OptionDescriptions.
    ['red', '#ff0000'].should.include cv.itemconfigure(rect, :fill)
  end

  it 'inserts, indexes and deletes characters in a text item' do
    cv = fresh_canvas
    text = cv.create_text(0, 0, text: 'Hello')
    cv.index(text, :end).should == 5

    cv.insert(text, 2, 'XX')
    cv.itemcget(text, :text).should == 'HeXXllo'
    cv.index(text, :end).should == 7

    cv.dchars(text, 2, 3)
    cv.itemcget(text, :text).should == 'Hello'
  end

  it 'sets focus and the insertion cursor on a text item' do
    cv = fresh_canvas
    text = cv.create_text(0, 0, text: 'Hello')
    cv.focus(text)
    cv.focus.should == text.id
    cv.icursor(text, 2)
    cv.index(text, :insert).should == 2
  end

  it 'manages the selection' do
    cv = fresh_canvas
    text = cv.create_text(0, 0, text: 'Hello')
    cv.select_item.should.nil?

    cv.select_from(text, 1)
    cv.select_to(text, 3)
    cv.select_item.should == text.id

    cv.select_clear
    cv.select_item.should.nil?
  end

  it 'reports the visible view fractions' do
    cv = fresh_canvas
    cv.xview.should == [0.0, 1.0]
    cv.yview.should == [0.0, 1.0]
  end

  it 'renders postscript' do
    cv = fresh_canvas
    cv.create_rectangle(10, 10, 50, 50, fill: 'black')
    ps = cv.postscript
    ps.should.be.kind_of String
    ps.should.not.be.empty
    ps[0, 3].should == '%!P'
  end

  it 'creates an oval and round-trips a fill' do
    cv = fresh_canvas
    oval = cv.create_oval(0, 0, 30, 20, fill: 'red')
    oval.coords.should == [0.0, 0.0, 30.0, 20.0]
    ['red', '#ff0000'].should.include oval.fill
    oval.type.should == :oval
  end

  it 'creates a bitmap item' do
    cv = fresh_canvas
    bitmap = cv.create_bitmap(15, 25, bitmap: 'error')
    bitmap.coords.should == [15.0, 25.0]
    bitmap.bitmap.should == 'error'
    bitmap.type.should == :bitmap
  end

  it 'creates an image item' do
    cv = fresh_canvas
    image = cv.create_image(5, 6)
    image.coords.should == [5.0, 6.0]
    image.type.should == :image
  end

  it 'delegates through Canvas::Item instance methods' do
    cv = fresh_canvas
    rect = cv.create_rectangle(10, 10, 50, 50)

    rect.coords.should == [10.0, 10.0, 50.0, 50.0]
    rect.type.should == :rectangle

    rect.move(5, 5)
    rect.coords.should == [15.0, 15.0, 55.0, 55.0]

    rect.addtag('flagged')
    rect.gettags.should == ['flagged']
    rect.dtag('flagged')
    rect.gettags.should == []

    rect.configure(fill: 'blue')
    ['blue', '#0000ff'].should.include rect.fill

    rect.delete
    cv.type(rect).should.nil?
  end
end

# %w[ ].each{|name| puts "@line.%s.should == nil" % [name.delete(':,')] }
