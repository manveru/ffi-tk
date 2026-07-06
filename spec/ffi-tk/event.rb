# frozen_string_literal: true

require_relative '../helper'

describe Tk::Event do
  it 'gives a list of defined virtual events' do
    Tk::Event.info.sort.unshift('<<Clear>>').uniq.should ==  [
      '<<Clear>>', '<<ContextMenu>>', '<<Copy>>', '<<Cut>>', '<<LineEnd>>', '<<LineStart>>', '<<NextChar>>', '<<NextLine>>', '<<NextPara>>', '<<NextWindow>>', '<<NextWord>>', '<<Paste>>', '<<PasteSelection>>', '<<PrevChar>>', '<<PrevLine>>', '<<PrevPara>>', '<<PrevWindow>>', '<<PrevWord>>', '<<Redo>>', '<<SelectAll>>', '<<SelectLineEnd>>', '<<SelectLineStart>>', '<<SelectNextChar>>', '<<SelectNextLine>>', '<<SelectNextPara>>', '<<SelectNextWord>>', '<<SelectNone>>', '<<SelectPrevChar>>', '<<SelectPrevLine>>', '<<SelectPrevPara>>', '<<SelectPrevWord>>', '<<ToggleSelection>>', '<<Undo>>'
    ]
    # tk-aqua: <<Clear>>, ...
  end

  it 'shows what sequences invoke a specific virtual event' do
    info = Tk::Event.info('<<Paste>>')
    info.should.is_a? Array
    %w[<Control-Key-v> <Mod1-Key-v>].should.include info.first
    # "<Control-Key-v>", "<Key-F18>", "<Control-Key-y>"
    # "<Control-Key-v>", "<Key-F18>", "<Control-Lock-Key-V>", "<Control-Key-y>"
    # tk-aqua: "<Mod1-Key-v>", "<Key-F4>", "<Control-Lock-Key-V>"
  end

  it 'adds a virtual event' do
    Tk::Event.add('<<Spec>>', '<Control-Alt-Key-Escape>')
    Tk::Event.info.should.include('<<Spec>>')
    Tk::Event.info('<<Spec>>').should == ['<Control-Alt-Key-Escape>']
  end

  it 'deletes a virtual event' do
    Tk::Event.delete('<<Spec>>', '<Control-Alt-Key-Escape>')
    Tk::Event.info.should.not.include('<<Spec>>')
    Tk::Event.info('<<Spec>>').should == []
  end

  it 'generates a virtual event and calls it' do
    Tk::Event.add('<<Clear>>', '<BackSpace>')

    entry = Tk::Entry.new('.')
    entry.bind('<<Clear>>') { entry.delete(0, :end) }
    entry.bind('<Map>') do
      Tk::Event.generate(entry, '<<Clear>>')
      Tk.interp.do_one_event
    end
    entry.insert 0, 'Hello, World!'
    entry.get.should == 'Hello, World!'

    entry.pack
    entry.focus

    Tk.interp.do_events_until do
      entry.get.empty?
    end

    entry.get.should == ''
  end

  it 'generates a virtual event and calls normal event' do
    Tk::Event.add('<<Clear>>', '<BackSpace>')

    entry = Tk::Entry.new('.')
    entry.bind('<<Clear>>') { entry.delete(0, :end) }
    entry.bind('<Map>') do
      entry.focus
      Tk::Event.generate(entry, '<BackSpace>')
      Tk.interp.do_one_event
    end
    entry.insert 0, 'Hello, World!'
    entry.get.should == 'Hello, World!'

    entry.pack
    entry.focus

    Tk.interp.do_events_until do
      entry.get.empty?
    end

    entry.get.should == ''
  end

  it 'associates event with button and calls it' do
    entered = false

    entry = Tk::Entry.new('.')
    entry.bind('<Key>') do
      entered = true
      Tk.stop
    end
    entry.bind('<Map>') do
      entry.focus
      Tk::Event.generate(entry, '<KeyPress-a>')
    end

    entry.pack
    entry.focus

    Tk.interp.do_events_until do
      entered
    end

    entered.should == true
  end

  # Bind a handler that captures the delivered Event::Data, synthesize an event
  # with explicit fields, then assert those fields survive the %-substitution
  # round-trip into the struct. The handler only stashes the object; the wait
  # loop reads it afterwards.
  def capture(sequence, options)
    captured = nil
    entry = Tk::Entry.new('.')
    entry.bind(sequence) { |event| captured = event }
    entry.bind('<Map>') do
      entry.focus
      Tk::Event.generate(entry, sequence, options)
    end
    entry.pack
    entry.focus
    Tk.interp.do_events_until { captured }
    [entry, captured]
  end

  it 'marshals KeyPress fields into the Event::Data struct' do
    entry, event = capture('<KeyPress>', keysym: 'a', x: 11, y: 22)

    event.type.should == 2 # KeyPress
    event.keysym.should == 'a'
    event.keysym.should.is_a? String
    event.unicode.should == 'a'
    event.x.should == 11
    event.x.should.is_a? Integer
    event.y.should == 22
    event.window_path.should == entry.tk_pathname
    event.widget.should == entry # window_path resolved back to the widget
  end

  it 'marshals ButtonPress fields into the Event::Data struct' do
    _entry, event = capture('<ButtonPress>', button: 3, x: 7, y: 9)

    event.type.should == 4 # ButtonPress
    event.button.should == 3
    event.button.should.is_a? Integer
    event.x.should == 7
    event.y.should == 9
  end

  it 'marshals Motion coordinates into the Event::Data struct' do
    _entry, event = capture('<Motion>', x: 44, y: 55)

    event.type.should == 6 # Motion
    event.x.should == 44
    event.y.should == 55
    event.x.should.is_a? Integer
  end

  it 'resends a captured event as a virtual event, preserving and overriding fields' do
    Tk::Event.add('<<Echo>>', '<Control-e>')

    resent = nil
    _entry, event = capture('<ButtonPress>', button: 2, x: 5, y: 6)
    event.widget.bind('<<Echo>>') { |ev| resent = ev }

    event.resend(event.widget, '<<Echo>>', x: 99)
    Tk.interp.do_events_until { resent }

    resent.x.should == 99 # overridden via changes
    resent.y.should == 6  # preserved from the original event
  end

  it 'unbinds and rebinds a sequence' do
    count = 0
    entry = Tk::Entry.new('.')
    entry.bind('<KeyPress>') { count += 1 }

    entry.bind('<KeyPress>').should.not.be.empty # script installed
    entry.bind('<Map>') do
      entry.focus
      Tk::Event.generate(entry, '<KeyPress>', keysym: 'a')
    end
    entry.pack
    entry.focus
    Tk.interp.do_events_until { count > 0 }
    count.should == 1

    entry.unbind('<KeyPress>')
    entry.bind('<KeyPress>').should.be.empty # script removed

    before = count
    Tk::Event.generate(entry, '<KeyPress>', keysym: 'b')
    Tk.interp.do_one_event
    count.should == before # unbound handler does not fire

    rebound = 0
    entry.bind('<KeyPress>') { rebound += 1 }
    Tk.interp.do_events_until do
      Tk::Event.generate(entry, '<KeyPress>', keysym: 'c')
      rebound > 0
    end
    rebound.should > 0
  end
end
