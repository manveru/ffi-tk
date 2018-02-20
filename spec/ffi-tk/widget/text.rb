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
    background: %w(systemWindowBody #282828),
    bd: [0, 1],
    bg: %w(systemWindowBody #ffffff #282828),
    blockcursor: [false],
    borderwidth: [0, 1],
    cursor: ['xterm'],
    endline: ['', 0],
    exportselection: [true],
    fg: %w(Black #000000 #ebdbb2),
    font: %w(TkFixedFont),
    foreground: %w(Black #000000 #ebdbb2),
    height: [24],
    highlightbackground: %w(systemWindowBody #d9d9d9),
    highlightcolor: %w(Black #000000),
    highlightthickness: [3, 1],
    inactiveselectbackground: %w(systemHighlightSecondary #c3c3c3),
    insertbackground: %w(Black #000000),
    insertborderwidth: [0],
    insertofftime: [300],
    insertontime: [600],
    insertwidth: [1, 2],
    maxundo: [0],
    padx: [1],
    pady: [1],
    relief: [:flat, :sunken],
    selectbackground: %w(systemHighlight #c3c3c3),
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
    text.count(1.0, :end, :displaylines).should == 13
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
    text.count(1.0, :end, :ypixels).should == 182
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
    text.mark_names.sort.should == [:current, :insert]
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
    text.mark_names.sort.should == [:current, :foo, :insert]
  end

  it 'unsets a mark' do
    text.mark_unset('foo')
    text.mark_names.sort.should == [:current, :insert]
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
  text.insert(:end, <<-TEXT)
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
      text.search(/e[t]/,          '1.0', :end).should == ['1.13']
      text.search(/E[T]/i,         '1.0', :end).should == ['1.13']
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

  # TODO: image handling
end
