# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Text do
  text = Tk::Text.new
  text.insert :end, 'Hello, World!'

  it 'gets the text at index' do
    text.get('end').should == ''
    text.get('1.0').should == 'H'
  end

  it 'gets text between two indices' do
    text.get('1.0', 'end').should == "Hello, World!\n"
  end

  cget_options = {
    autoseparators: [true],
    background: %w[systemWindowBody #ffffff #282828],
    bd: [0, 1],
    bg: %w[systemWindowBody #ffffff #282828],
    blockcursor: [false],
    borderwidth: [0, 1],
    cursor: ['xterm'],
    endline: ['', 0],
    exportselection: [true],
    fg: %w[Black #000000 #ebdbb2],
    font: %w[TkFixedFont],
    foreground: %w[Black #000000 #ebdbb2],
    height: [24],
    highlightbackground: %w[systemWindowBody #d9d9d9],
    highlightcolor: %w[Black #000000],
    highlightthickness: [3, 1],
    inactiveselectbackground: %w[systemHighlightSecondary #c3c3c3],
    insertbackground: %w[Black #000000],
    insertborderwidth: [0],
    insertofftime: [300],
    insertontime: [600],
    insertwidth: [1, 2],
    maxundo: [0],
    padx: [1],
    pady: [1],
    relief: %i[flat sunken],
    selectbackground: %w[systemHighlight #c3c3c3],
    selectborderwidth: [1, 0],
    selectforeground: [nil, '#000000'],
    setgrid: [false],
    spacing1: [0],
    spacing2: [0],
    spacing3: [0],
    startline: [0, ''],
    state: [['normal']],
    tabs: [nil],
    tabstyle: [:tabular],
    takefocus: [false],
    undo: [false, true],
    width: [80],
    wrap: [:char],
    xscrollcommand: [nil],
    yscrollcommand: [nil]
  }

  describe 'getting options via cget' do
    cget_options.each do |key, values|
      it "returns a member of #{values.inspect} for -#{key}" do
        values.should.include text.cget(key)
      end
    end
  end

  it 'configures a single option' do
    text.cget(:wrap).should == :char
    text.configure(wrap: :word)
    text.cget(:wrap).should == :word
  end

  it 'configures more options at once' do
    text.cget(:width).should == 80
    text.cget(:height).should == 24
    text.configure(width: 20, height: 20)
    text.cget(:width).should == 20
    text.cget(:height).should == 20
  end

  it 'compares two indices' do
    text.compare('1.0', '==', '1.1').should == false
    text.compare('1.0', '>',  '1.1').should == false
    text.compare('1.0', '<',  '1.1').should == true
    text.compare('1.0', '!=', '1.1').should == true
    text.compare('1.0', '<=', '1.1').should == true
    text.compare('1.0', '>=', '1.1').should == false
  end

  it 'counts chars' do
    text.count('1.0', 'end', :chars).should == 14
  end

  it 'counts displaychars' do
    text.count(1.0, :end, :displaychars).should == 14
  end

  it 'counts displayindices' do
    text.count(1.0, :end, :displayindices).should == 14
  end

  it 'counts displaylines' do
    # font-metric dependent (wrapping), varies by a line across systems
    (11..14).should.include text.count(1.0, :end, :displaylines)
  end

  it 'counts indices' do
    text.count(1.0, :end, :indices).should == 14
  end

  it 'counts lines' do
    text.count(1.0, :end, :lines).should == 1
  end

  it 'counts xpixels' do
    text.count(1.0, :end, :xpixels).should == 0
  end

  it 'counts ypixels' do
    # font-metric dependent (line height in pixels), varies by a few px
    (176..186).should.include text.count(1.0, :end, :ypixels)
  end

  should 'not be in debug mode' do
    text.debug?.should == false
  end

  it 'deletes at index' do
    text.delete(1.0)
    text.get(1.0, 'end').should == "ello, World!\n"
  end

  it 'deletes between indices' do
    text.delete(1.2, 1.5)
    text.get(1.0, 'end').should == "el World!\n"
  end

  it 'gives line info' do
    info = text.dlineinfo(1.0)
    info.size.should == 5
    info.all? { |i| i.is_a?(Integer) }
  end

  it 'inserts string with taglist' do
    text.insert(1.0, 'H', 'start')
    text.get(1.0, :end).should == "Hel World!\n"
  end

  it 'queries mark gravity' do
    text.mark_gravity(:insert).should == :right
  end

  it 'changes mark gravity' do
    text.mark_gravity(:insert, :left)
    text.mark_gravity(:insert).should == :left
    text.mark_gravity(:insert, :right)
  end

  it 'lists mark names' do
    text.mark_names.sort.should == %i[current insert]
  end

  it 'answers with the next mark after index' do
    text.mark_next('1.0').should == :insert
    text.mark_next(:insert).should == :current
    text.mark_next(:current).should.be.nil
  end

  it 'ansewrs with the previous mark before index' do
    text.mark_previous(:end).should == :current
    text.mark_previous(:current).should == :insert
    text.mark_previous(:insert).should.be.nil
  end

  it 'sets a mark' do
    text.mark_set('foo', '1.3')
    text.mark_names.sort.should == %i[current foo insert]
  end

  it 'unsets a mark' do
    text.mark_unset('foo')
    text.mark_names.sort.should == %i[current insert]
  end

  it 'creates a peer' do
    @peer = text.peer_create
    @peer.tk_pathname.should == '.text0.text1'
  end

  it 'lists the peer' do
    text.peer_names.should == ['.text0.text1']
  end

  it 'destroys the peer' do
    @peer.destroy
    text.peer_names.should == []
  end

  it 'searches for {}' do
    text.insert :end, '{ now some text in here}'
    text.search(/\{/, '1.0', 'end', :all).should == ['1.10']
    text.search(/\}/, '1.0', 'end', :all).should == ['1.33']
    text.search(/[{}]/, '1.0', 'end', :all).should == ['1.10', '1.33']
  end

  text.delete '1.0', 'end'
  text.insert(:end, <<~TEXT)
    Est magni ex et voluptatem possimus deserunt qui. Ex necessitatibus molestiae aperiam illo. Voluptatem omnis eum illum tenetur inventore. Exercitationem non voluptatem et. Aut molestiae exercitationem veritatis voluptates unde nam possimus dolore.
    Ea dolores qui et odit officia quibusdam autem. Optio quia inventore aspernatur. Eos ipsam maxime sed dignissimos minus. Mollitia fugiat voluptate sunt non illum nam adipisci.
    Reprehenderit soluta laudantium dicta illo fuga sit illum. Enim placeat rerum sunt dicta in sed. Enim quia rerum ducimus.
    Et nam eum veritatis aut. Deleniti praesentium voluptatem quis ab et. Voluptas est ratione sunt quis nam recusandae autem nemo. Ad fugiat maxime aut et odio.
    Nostrum possimus nisi iure inventore corporis. Voluptatem omnis est tempore est aliquam ut. Corporis quia totam in fuga dolorum. Nihil et aut voluptatem aliquid dolor. Iure tempora iste quia.
    Reprehenderit perferendis sit vel aliquam dolor eum repellat. Odit dicta consequatur nulla maiores et. Cumque quia excepturi ea autem velit eos.
    Pariatur reiciendis quis est magni et. Nostrum aperiam ipsa ullam ad excepturi aliquam repellat. Sequi dolor saepe tenetur. Sunt nihil reiciendis ea non odit quia.
    Blanditiis sunt reiciendis non qui repellendus fugit. Esse dolorum aut unde nobis cupiditate expedita. Quae natus rerum temporibus.
    Dolor enim sint delectus quo fuga provident qui eum. Nisi commodi dolores dolorem amet officiis ipsam voluptatum. Et possimus corporis et aliquam cum omnis. Laudantium sed aut officiis.
    Eligendi voluptas nostrum magni ea dolores ut vel in. Quas aspernatur deleniti possimus autem qui neque facere. Dolores alias non quibusdam repellendus consequatur voluptatem. Quisquam quae fuga et eum doloremque rerum. Qui optio doloremque voluptates esse deserunt doloribus voluptatem illo.
    Voluptatum molestiae voluptatibus sequi sed a. In beatae doloribus molestiae. Eos officiis ea voluptate praesentium est. Quod dolore earum accusamus et.
    Harum nesciunt qui dolores necessitatibus blanditiis enim incidunt non. Similique et odio quos voluptas tempore in veritatis. Labore rerum asperiores doloribus aperiam cupiditate. Dolorum provident assumenda illum amet id modi voluptas.
    Et recusandae itaque atque aliquam. Perspiciatis non est quasi assumenda veniam consectetur. Officia rerum sed odio aut voluptatem eos repellendus exercitationem. Tempora quis expedita et quis eos. Ut dolor est et.
    Minus soluta architecto ratione repudiandae magni maxime. Dolorem beatae dolorem fugiat amet maxime. Est sint molestiae officia quisquam aperiam sit eaque.
    Voluptatem magnam occaecati laboriosam fugiat natus ex et. Unde id veritatis dignissimos ipsa. Natus eaque facilis deleniti et quos asperiores eos. Deserunt expedita blanditiis aut.
    Accusamus cumque itaque voluptatem dolores. Et et quos et dolor necessitatibus. Voluptatem voluptatem temporibus provident. Consectetur sequi id rerum.
    Molestiae quia ipsa eos minus cupiditate tempora quasi consequuntur. Dolores nisi consequatur et fugiat culpa eius quos et. Ipsum eos qui eius dolorem nisi.
    Repellat veniam sint consectetur dicta quia quas eos numquam. Sint libero temporibus et ad quia rerum. Expedita aut a odit non et nostrum.
    Saepe voluptas architecto debitis tenetur voluptatem cum rerum. Assumenda unde possimus eum et accusantium. Reiciendis voluptas repellendus magnam tempore est perferendis ut. Qui cum et rerum pariatur.
    Voluptates dicta labore impedit deserunt quod. Vero sint rerum at asperiores eos. Saepe nam sint sint. Non et assumenda molestiae et sunt perferendis qui corrupti. Est velit qui quam.
  TEXT

  describe 'Text#search' do
    it 'searches by exact match' do
      text.search('et', '1.0', :end).should == ['1.13']
      text.search('labore', '1.0', :end).should == ['20.17']
    end

    it 'searches by regular expression' do
      text.search(/et/,          '1.0', :end).should == ['1.13']
      text.search(/ET/i,         '1.0', :end).should == ['1.13']
      text.search(/DOLORE\.\nEA/i, '1.0', :end).should == ['1.240']
    end

    it 'searches with regexp and switches' do
      text.search(/DOLORE\..EA/i, '1.0', :end, :nolinestop).should == ['1.240']
    end

    it 'searches with :count' do
      text.search('et', '1.0', :end, :count).should == ['1.13', 2]
      text.search('velit', '1.0', :end, :all, :count).should == [['6.134', 5], ['20.168', 5]]
    end
  end

  # Fresh widgets below are created inside `it` blocks (never at describe-body
  # load time) so the global `text` command counter is not advanced before the
  # peer specs above run and assert the exact pathname `.text0.text1`.

  describe 'Text#index' do
    it 'resolves indices to line.char form' do
      t = Tk::Text.new
      t.insert :end, "abc\ndef"
      t.index('1.0').should == '1.0'
      t.index(:end).should == '3.0'
      t.index('1.0 + 1 char').should == '1.1'
      t.index('1.0 lineend').should == '1.3'
    end
  end

  describe 'Text#get' do
    it 'returns a String for a single range' do
      t = Tk::Text.new
      t.insert :end, 'hello world'
      t.get('1.0', '1.5').should == 'hello'
    end

    it 'returns a list of Strings for multiple ranges' do
      t = Tk::Text.new
      t.insert :end, 'hello world'
      t.get('1.0', '1.5', '1.6', '1.11').should == %w[hello world]
    end

    it 'returns only non-elided text via get_displaychars' do
      t = Tk::Text.new
      t.insert :end, 'abcdef'
      t.tag_add('hidden', '1.3', '1.6')
      t.tag_configure('hidden', elide: true)
      t.get('1.0', :end).should == "abcdef\n"
      t.get_displaychars('1.0', :end).should == "abc\n"
    end
  end

  describe 'Text#value' do
    it 'round-trips content through value= and value' do
      t = Tk::Text.new
      t.value = 'some content'
      # A text widget always keeps a trailing newline.
      t.value.should == "some content\n"
    end

    it 'clears all content' do
      t = Tk::Text.new
      t.value = 'stuff to remove'
      t.clear
      t.value.should == "\n"
    end
  end

  describe 'Text#count' do
    it 'counts several options at once, returning one integer per option' do
      t = Tk::Text.new
      t.insert :end, "one\ntwo\nthree"
      chars, lines = t.count('1.0', :end, :chars, :lines)
      chars.should == t.value.length
      lines.should == t.value.count("\n")
    end

    it 'counts a negative span when index1 is after index2' do
      t = Tk::Text.new
      t.insert :end, 'abcdef'
      t.count('1.6', '1.0', :chars).should == -6
    end
  end

  describe 'Text#dump' do
    it 'dumps text segments as [type, value, index] triples' do
      t = Tk::Text.new
      t.insert :end, "line one\nline two\n"
      t.dump(:text, '1.0', '2.0').should == [['text', "line one\n", '1.0']]
    end

    it 'dumps mark segments' do
      t = Tk::Text.new
      t.insert :end, "abc\n"
      t.mark_set('here', '1.2')
      marks = t.dump(:mark, '1.0', :end)
      marks.should.include(['mark', 'here', '1.2'])
    end

    it 'dumps tag on/off segments' do
      t = Tk::Text.new
      t.insert :end, "hello\n"
      t.tag_add('em', '1.0', '1.3')
      t.dump(:tag, '1.0', '1.5').should == [
        ['tagon', 'em', '1.0'],
        ['tagoff', 'em', '1.3']
      ]
    end

    it 'dumps all segment kinds interleaved' do
      t = Tk::Text.new
      t.insert :end, "hello\n"
      t.tag_add('em', '1.0', '1.3')
      t.dump(:all, '1.0', '1.5').should == [
        ['tagon', 'em', '1.0'],
        ['text', 'hel', '1.0'],
        ['tagoff', 'em', '1.3'],
        ['text', 'lo', '1.3']
      ]
    end
  end

  describe 'Text edit / undo stack' do
    it 'round-trips undo and redo' do
      t = Tk::Text.new
      t.configure(undo: true, autoseparators: false)
      t.insert :end, 'abc'
      t.edit_separator
      t.insert :end, 'def'
      t.value.should == "abcdef\n"
      t.edit_undo
      t.value.should == "abc\n"
      t.edit_redo
      t.value.should == "abcdef\n"
    end

    it 'tracks and clears the modified flag' do
      t = Tk::Text.new
      t.edit_modified(false)
      t.edit_modified?.should == false
      t.insert :end, 'typing'
      t.edit_modified?.should == true
      t.edit_modified(false)
      t.edit_modified?.should == false
    end

    it 'resets the undo stack so there is nothing left to undo' do
      t = Tk::Text.new
      t.configure(undo: true, autoseparators: false)
      t.insert :end, 'keep'
      t.edit_reset
      # With the stack cleared, Tk raises rather than reverting the insert.
      -> { t.edit_undo }.should.raise(RuntimeError)
      t.value.should == "keep\n"
    end
  end

  describe 'Text#replace' do
    it 'replaces a range with new characters' do
      t = Tk::Text.new
      t.value = 'hello world'
      t.replace('1.0', '1.5', 'HI')
      t.value.should == "HI world\n"
    end
  end

  describe 'Text tags' do
    it 'adds a tag and reports its ranges' do
      t = Tk::Text.new
      t.insert :end, "line one\nline two\n"
      t.tag_add('hi', '1.0', '1.4')
      t.tag_add('hi', '2.0', '2.3')
      t.tag_ranges('hi').should == [['1.0', '1.4'], ['2.0', '2.3']]
    end

    it 'lists tag names globally and at an index' do
      t = Tk::Text.new
      t.insert :end, "abc\n"
      t.tag_add('hi', '1.0', '1.2')
      t.tag_names.should.include('hi')
      t.tag_names('1.1').should == ['hi']
      t.tag_names('1.3').should == []
    end

    it 'finds the next and previous tagged range' do
      t = Tk::Text.new
      t.insert :end, "line one\nline two\n"
      t.tag_add('hi', '1.0', '1.4')
      t.tag_add('hi', '2.0', '2.3')
      t.tag_nextrange('hi', '1.0').should == ['1.0', '1.4']
      t.tag_nextrange('hi', '1.4').should == ['2.0', '2.3']
      t.tag_prevrange('hi', :end).should == ['2.0', '2.3']
      t.tag_nextrange('hi', :end).should == []
    end

    it 'removes a tag from a range without deleting it' do
      t = Tk::Text.new
      t.insert :end, "line one\nline two\n"
      t.tag_add('hi', '1.0', '1.4')
      t.tag_add('hi', '2.0', '2.3')
      t.tag_remove('hi', '1.0', '1.4')
      t.tag_ranges('hi').should == [['2.0', '2.3']]
      t.tag_names.should.include('hi')
    end

    it 'deletes a tag entirely' do
      t = Tk::Text.new
      t.insert :end, "abc\n"
      t.tag_add('gone', '1.0', '1.2')
      t.tag_names.should.include('gone')
      t.tag_delete('gone')
      t.tag_names.should.not.include('gone')
    end

    it 'round-trips tag options through tag_configure and tag_cget' do
      t = Tk::Text.new
      t.insert :end, "abc\n"
      t.tag_add('col', '1.0', '1.2')
      t.tag_cget('col', :foreground).should.be.nil
      t.tag_configure('col', foreground: 'red', background: 'blue')
      t.tag_cget('col', :foreground).should == 'red'
      t.tag_cget('col', :background).should == 'blue'
      t.tag_configure('col').should.be.kind_of(Hash)
    end

    it 'reorders tag priority with lower and raise' do
      t = Tk::Text.new
      t.insert :end, "abc\n"
      t.tag_add('a', '1.0', '1.1')
      t.tag_add('b', '1.1', '1.2')
      # Newest tag has highest priority; tag_names is lowest -> highest.
      t.tag_names.should == %w[sel a b]
      t.tag_lower('b', 'a')
      t.tag_names.should == %w[sel b a]
      t.tag_raise('b')
      t.tag_names.should == %w[sel a b]
    end
  end

  describe 'Text embedded windows' do
    it 'creates an embedded window and lists it' do
      t = Tk::Text.new
      t.insert :end, "abc\n"
      button = Tk::Button.new(t, text: 'x')
      t.window_create('1.1', window: button).should.be.nil
      t.window_names.should == [button.tk_pathname]
    end

    it 'queries an embedded window option via window_cget' do
      t = Tk::Text.new
      t.insert :end, "abc\n"
      button = Tk::Button.new(t, text: 'x')
      t.window_create('1.1', window: button)
      t.window_cget('1.1', :window).should == button.tk_pathname
    end

    it 'returns an empty list when no windows are embedded' do
      t = Tk::Text.new
      t.insert :end, "abc\n"
      t.window_names.should == []
    end
  end

  describe 'Text peers share content' do
    it 'reflects edits made in the parent widget' do
      t = Tk::Text.new
      t.insert :end, 'shared'
      peer = t.peer_create
      # A peer shares the parent's underlying content buffer.
      peer.value.should == t.value
      peer.value.should == "shared\n"
      t.insert :end, ' and more'
      peer.value.should == t.value
      peer.destroy
    end
  end

  describe 'Text#compare' do
    it 'evaluates every relational operator' do
      t = Tk::Text.new
      t.insert :end, "abc\ndef\n"
      t.compare('2.0', '==', '2.0').should == true
      t.compare('1.0', '<', '2.0').should == true
      t.compare('2.0', '>', '1.0').should == true
      t.compare('1.0', '!=', '2.0').should == true
      t.compare('2.0', '>=', '2.0').should == true
      t.compare('1.0', '>=', '2.0').should == false
    end
  end

  describe 'Text#bbox' do
    it 'returns the [x, y, w, h] screen area of a character' do
      t = Tk::Text.new(width: 40, height: 5)
      t.pack
      t.insert :end, "hello\n"
      next unless skip_unless_mapped(t)

      box = t.bbox('1.0')
      box.size.should == 4
      box.all? { |n| n.is_a?(Integer) }.should == true
      box[2].should > 0 # width
      box[3].should > 0 # height
    end
  end

  describe 'Text#see' do
    it 'scrolls a far-off index into view' do
      t = Tk::Text.new(width: 20, height: 3)
      t.pack
      100.times { |i| t.insert :end, "line #{i}\n" }
      next unless skip_unless_mapped(t)

      t.yview_moveto(0.0)
      Tk.execute('update')
      t.see('90.0')
      Tk.execute('update')
      # After seeing line 90, the top of the view must have scrolled past 1.0.
      t.compare(t.index('@0,0'), '>', '1.0').should == true
    end
  end

  # TODO: image handling
end
