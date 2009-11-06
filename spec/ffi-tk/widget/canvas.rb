require_relative '../../helper'

describe Tk::Canvas do
  it 'creates a canvas' do
    @canvas = Tk::Canvas.new
    @canvas.tk_pathname.should == '.tk::canvas0'
    @canvas.pack fill: :both, expand: true
  end

  it 'creates text' do
    @text = @canvas.create_text(0, 0, text: 'Hello, World!')
    @text.id.should == 1
    @text.canvas.should == @canvas

    @text.activefill.should == nil
    @text.activestipple.should == nil
    @text.anchor.should == "center"
    @text.disabledfill.should == nil
    @text.disabledstipple.should == nil
    @text.fill.should == "black"
    @text.font.should == "TkDefaultFont"
    @text.justify.should == :left
    @text.state.should == nil
    @text.stipple.should == nil
    @text.tags.should == []
    @text.text.should == "Hello, World!"
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
    @rect.fill.should == nil
    @rect.activefill.should == nil
    @rect.disabledfill.should == nil
    @rect.offset.should == '0,0'
    @rect.outline.should == 'black'
    @rect.activeoutline.should == nil
    @rect.disabledoutline.should == nil
    @rect.outlineoffset.should == 0
    @rect.outlinestipple.should == nil
    @rect.activeoutlinestipple.should == nil
    @rect.disabledoutlinestipple.should == nil
    @rect.stipple.should == nil
    @rect.activestipple.should == nil
    @rect.disabledstipple.should == nil
    @rect.state.should == nil
    @rect.tags.should == []
    @rect.width.should == 0
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
    @arc.fill.should == nil
    @arc.activefill.should == nil
    @arc.disabledfill.should == nil
    @arc.offset.should == '0,0'
    @arc.outline.should == 'black'
    @arc.activeoutline.should == nil
    @arc.disabledoutline.should == nil
    @arc.outlineoffset.should == 0.0
    @arc.outlinestipple.should == nil
    @arc.activeoutlinestipple.should == nil
    @arc.disabledoutlinestipple.should == nil
    @arc.stipple.should == nil
    @arc.activestipple.should == nil
    @arc.disabledstipple.should == nil
    @arc.state.should == nil
    @arc.tags.should == []
    @arc.width.should == 0
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
    @poly.fill.should == 'black'
    @poly.activefill.should == nil
    @poly.disabledfill.should == nil
    @poly.offset.should == '0,0'
    @poly.outline.should == nil
    @poly.activeoutline.should == nil
    @poly.disabledoutline.should == nil
    @poly.outlinestipple.should == nil
    @poly.activeoutlinestipple.should == nil
    @poly.disabledoutlinestipple.should == nil
    @poly.stipple.should == nil
    @poly.activestipple.should == nil
    @poly.disabledstipple.should == nil
    @poly.state.should == nil
    @poly.tags.should == []
    @poly.width.should == 0
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
    @line.fill.should == 'black'
    @line.activefill.should == nil
    @line.disabledfill.should == nil
    @line.stipple.should == nil
    @line.activestipple.should == nil
    @line.disabledstipple.should == nil
    @line.state.should == nil
    @line.tags.should == []
    @line.width.should == 0
    @line.activewidth.should == 0
    @line.disabledwidth.should == 0
    @line.arrow.should == :none
    @line.arrowshape.should == ["8", "10", "3"]
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

    @win.state.should == nil
    @win.tags.should == []
    @win.anchor.should == 'center'
    @win.height.should == 0
    @win.width.should == 0
    @win.window.should == entry
  end
end

# %w[ ].each{|name| puts "@line.%s.should == nil" % [name.delete(':,')] }