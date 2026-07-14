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
    @text.anchor.should == :center           # :symbol (keyword set)
    @text.disabledfill.should.nil?
    @text.disabledstipple.should.nil?
    ['black', '#000000'].should.include @text.fill
    @text.font.should == 'TkDefaultFont'
    @text.justify.should == :left
    @text.state.should.nil?
    @text.stipple.should.nil?
    @text.tags.should == []
    @text.text.should == 'Hello, World!'
    @text.underline.should == -1             # :integer character index
    @text.width.should == '0'                # :string (screen distance, wrap)
  end

  it 'creates a rectangle' do
    @rect = @canvas.create_rectangle(10, 11, 12, 13)
    @rect.id.should == 2
    @rect.canvas.should == @canvas

    # dash patterns are lossless :string (empty by default), not :integer.
    @rect.dash.should == ''
    @rect.activedash.should == ''
    @rect.disableddash.should == ''
    @rect.dashoffset.should == '0'           # :string (screen distance)
    @rect.fill.should.nil?
    @rect.activefill.should.nil?
    @rect.disabledfill.should.nil?
    @rect.offset.should == '0,0'             # :string (coordinate spec)
    ['black', '#000000'].should.include @rect.outline
    @rect.activeoutline.should.nil?
    @rect.disabledoutline.should.nil?
    @rect.outlineoffset.should == '0,0'      # :string (coordinate spec)
    @rect.outlinestipple.should.nil?
    @rect.activeoutlinestipple.should.nil?
    @rect.disabledoutlinestipple.should.nil?
    @rect.stipple.should.nil?
    @rect.activestipple.should.nil?
    @rect.disabledstipple.should.nil?
    @rect.state.should.nil?
    @rect.tags.should == []
    # outline widths are lossless screen distances (:string), reported as floats.
    @rect.width.should == '1.0'
    @rect.activewidth.should == '0.0'
    @rect.disabledwidth.should == '0.0'
  end

  it 'creates an arc' do
    @arc = @canvas.create_arc(20, 21, 22, 23)
    @arc.id.should == 3
    @arc.canvas.should == @canvas

    @arc.dash.should == ''
    @arc.activedash.should == ''
    @arc.disableddash.should == ''
    @arc.dashoffset.should == '0'
    @arc.fill.should.nil?
    @arc.activefill.should.nil?
    @arc.disabledfill.should.nil?
    @arc.offset.should == '0,0'
    ['black', '#000000'].should.include @arc.outline
    @arc.activeoutline.should.nil?
    @arc.disabledoutline.should.nil?
    @arc.outlineoffset.should == '0,0'
    @arc.outlinestipple.should.nil?
    @arc.activeoutlinestipple.should.nil?
    @arc.disabledoutlinestipple.should.nil?
    @arc.stipple.should.nil?
    @arc.activestipple.should.nil?
    @arc.disabledstipple.should.nil?
    @arc.state.should.nil?
    @arc.tags.should == []
    @arc.width.should == '1.0'
    @arc.activewidth.should == '0.0'
    @arc.disabledwidth.should == '0.0'
    @arc.extent.should == 90.0 # :float degrees
    @arc.start.should == 0.0 # :float degrees
    @arc.style.should == :pieslice
  end

  it 'creates a polygon' do
    @poly = @canvas.create_polygon(50, 50, 60, 60, 70, 70, 80, 70, 90, 60, 100, 50)
    @poly.id.should == 4
    @poly.canvas.should == @canvas

    @poly.dash.should == ''
    @poly.activedash.should == ''
    @poly.disableddash.should == ''
    @poly.dashoffset.should == '0'
    ['black', '#000000'].should.include @poly.fill
    @poly.activefill.should.nil?
    @poly.disabledfill.should.nil?
    @poly.offset.should == '0,0'
    @poly.outline.should.nil?
    @poly.activeoutline.should.nil?
    @poly.disabledoutline.should.nil?
    @poly.outlineoffset.should == '0,0'
    @poly.outlinestipple.should.nil?
    @poly.activeoutlinestipple.should.nil?
    @poly.disabledoutlinestipple.should.nil?
    @poly.stipple.should.nil?
    @poly.activestipple.should.nil?
    @poly.disabledstipple.should.nil?
    @poly.state.should.nil?
    @poly.tags.should == []
    @poly.width.should == '1.0'
    @poly.activewidth.should == '0.0'
    @poly.disabledwidth.should == '0.0'
    @poly.joinstyle.should == :round
    @poly.smooth.should == '0'               # :string (bool-or-method quad-state)
    @poly.splinesteps.should == 12           # :integer
  end

  it 'creates a line' do
    @line = @canvas.create_line(10, 15, 20, 25)
    @line.id.should == 5
    @line.canvas.should == @canvas

    @line.dash.should == ''
    @line.activedash.should == ''
    @line.disableddash.should == ''
    @line.dashoffset.should == '0'
    ['black', '#000000'].should.include @line.fill
    @line.activefill.should.nil?
    @line.disabledfill.should.nil?
    @line.stipple.should.nil?
    @line.activestipple.should.nil?
    @line.disabledstipple.should.nil?
    @line.state.should.nil?
    @line.tags.should == []
    @line.width.should == '1.0'
    @line.activewidth.should == '0.0'
    @line.disabledwidth.should == '0.0'
    @line.arrow.should == :none
    @line.arrowshape.should == %w[8 10 3]    # :list of screen distances
    @line.capstyle.should == :butt
    @line.joinstyle.should == :round
    @line.smooth.should == '0'               # :string (bool-or-method quad-state)
    @line.splinesteps.should == 12           # :integer
  end

  it 'creates a window' do
    entry = Tk::Entry.new(Tk.root)
    @win = @canvas.create_window(10, 10, window: entry)
    @win.id.should == 6
    @win.canvas.should == @canvas

    @win.state.should.nil?
    @win.tags.should == []
    @win.anchor.should == :center            # :symbol (keyword set)
    @win.height.should == '0'                # :string (screen distance)
    @win.width.should == '0'                 # :string (screen distance)
    @win.window.should == entry              # :pathname -> the Widget
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

  it 'round-trips options via itemconfigure/itemcget, coerced by the item schema' do
    cv = fresh_canvas
    rect = cv.create_rectangle(0, 0, 10, 10)
    cv.itemconfigure(rect, fill: 'red', width: 3)
    ['red', '#ff0000'].should.include cv.itemcget(rect, :fill) # :color
    # -width is a lossless screen distance (:string), reported as a float.
    cv.itemcget(rect, :width).should == '3.0'
    rect.width.should == '3.0' # typed reader routes through cget

    # itemconfigure now routes through the item's Option schema, so a
    # single-option query returns that option's coerced OptionDescription
    # (matching the widget-level configure), not a bare value.
    description = cv.itemconfigure(rect, :fill)
    description.should.be.is_a? Tk::OptionDescription
    description.name.should == :fill
    ['red', '#ff0000'].should.include description.value
  end

  it 'itemconfigure lists every item option as a coerced OptionDescription' do
    cv = fresh_canvas
    rect = cv.create_rectangle(0, 0, 10, 10)
    cv.itemconfigure(rect, fill: 'red', width: 2)

    descriptions = cv.itemconfigure(rect)
    descriptions.should.be.is_a? Hash
    ['red', '#ff0000'].should.include descriptions[:fill].value  # :color
    descriptions[:width].value.should == '2.0'                   # :string
    descriptions[:state].value.should.be.nil                     # unset :symbol
    descriptions[:dash].value.should == ''                       # unset :string
  end

  it 'coerces item options by their declared type across item types' do
    cv = fresh_canvas

    arc = cv.create_arc(0, 0, 40, 40)
    cv.itemconfigure(arc, extent: 120, start: 30, style: 'chord')
    cv.itemcget(arc, :extent).should == 120.0 # :float
    cv.itemcget(arc, :start).should == 30.0      # :float
    cv.itemcget(arc, :style).should == :chord    # :symbol

    line = cv.create_line(0, 0, 10, 10, 20, 0)
    cv.itemconfigure(line, arrow: 'both', smooth: true, splinesteps: 8)
    cv.itemcget(line, :arrow).should == :both     # :symbol
    cv.itemcget(line, :smooth).should == 'true'   # :string (boolean value)
    cv.itemcget(line, :splinesteps).should == 8   # :integer

    # -smooth is quad-state: a boolean OR a smoothing-method name. A non-boolean
    # method (raw/bezier/custom) must read back faithfully, not be flattened to
    # a boolean (which would report the enabled 'raw' method as false).
    cv.execute_only(:itemconfigure, line, '-smooth', 'raw')
    cv.itemcget(line, :smooth).should == 'raw'    # :string, not false

    text = cv.create_text(0, 0, text: 'hi')
    cv.itemconfigure(text, justify: 'right', underline: 1)
    cv.itemcget(text, :justify).should == :right  # :symbol
    cv.itemcget(text, :underline).should == 1      # :integer

    button = Tk::Button.new(Tk.root, text: 'x')
    win = cv.create_window(60, 60, window: button)
    cv.itemcget(win, :window).should == button     # :pathname -> the Widget
    cv.itemcget(win, :anchor).should == :center # :symbol
  end

  it 'itemcget resolves the item schema from a bare tag or id' do
    cv = fresh_canvas
    rect = cv.create_rectangle(0, 0, 10, 10)
    cv.addtag_withtag('marker', rect)
    cv.itemconfigure('marker', fill: 'blue')

    # Passing the raw integer id (not the Item) still coerces by type, because
    # itemcget resolves the schema through the canvas's `type` query.
    ['blue', '#0000ff'].should.include cv.itemcget(rect.id, :fill)
    cv.itemcget(rect.id, :width).should == '1.0'
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

  it 'rebinds an item/tag event without leaking the old handler' do
    cv = fresh_canvas
    cv.create_rectangle(0, 0, 10, 10, tags: 'r')
    cv.bind('r', '<Button-1>') { |_e| }
    cv.bind('r', '<Button-1>') { |_e| } # rebind must not raise
    Tk.execute(cv.tk_pathname, :bind, 'r', '<Button-1>').to_s.should =~ /RubyFFI::event/
  end

  it 'reports the visible view fractions as floats' do
    cv = fresh_canvas
    cv.xview.should == [0.0, 1.0]
    cv.yview.should == [0.0, 1.0]
    cv.xview.all? { |n| n.is_a?(Float) }.should == true
    cv.yview.all? { |n| n.is_a?(Float) }.should == true
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
