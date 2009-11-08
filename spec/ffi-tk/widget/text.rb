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

  it 'gets all possible options with cget' do
    text.cget(:autoseparators          ).should == true
    text.cget(:background              ).should == "#ffffff"
    text.cget(:bd                      ).should == 1
    text.cget(:bg                      ).should == "#ffffff"
    text.cget(:blockcursor             ).should == false
    text.cget(:borderwidth             ).should == 1
    text.cget(:cursor                  ).should == "xterm"
    text.cget(:endline                 ).should == 0
    text.cget(:exportselection         ).should == true
    text.cget(:fg                      ).should == "#000000"
    text.cget(:font                    ).should == "TkFixedFont"
    text.cget(:foreground              ).should == "#000000"
    text.cget(:height                  ).should == 24
    text.cget(:highlightbackground     ).should == "#d9d9d9"
    text.cget(:highlightcolor          ).should == "#000000"
    text.cget(:highlightthickness      ).should == 1
    text.cget(:inactiveselectbackground).should == "#c3c3c3"
    text.cget(:insertbackground        ).should == "#000000"
    text.cget(:insertborderwidth       ).should == 0
    text.cget(:insertofftime           ).should == 300
    text.cget(:insertontime            ).should == 600
    text.cget(:insertwidth             ).should == 2
    text.cget(:maxundo                 ).should == 0
    text.cget(:padx                    ).should == 1
    text.cget(:pady                    ).should == 1
    text.cget(:relief                  ).should == :sunken
    text.cget(:selectbackground        ).should == "#c3c3c3"
    text.cget(:selectborderwidth       ).should == 0
    text.cget(:selectforeground        ).should == "#000000"
    text.cget(:setgrid                 ).should == false
    text.cget(:spacing1                ).should == 0
    text.cget(:spacing2                ).should == 0
    text.cget(:spacing3                ).should == 0
    text.cget(:startline               ).should == 0
    text.cget(:state                   ).should == ['normal']
    text.cget(:tabs                    ).should == nil
    text.cget(:tabstyle                ).should == :tabular
    text.cget(:takefocus               ).should == false
    text.cget(:undo                    ).should == false
    text.cget(:width                   ).should == 80
    text.cget(:wrap                    ).should == :char
    text.cget(:xscrollcommand          ).should == nil
    text.cget(:yscrollcommand          ).should == nil
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
    text.count(1.0, :end, :ypixels).should == 195
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
    info.all?{|i| i.kind_of?(Fixnum) }
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
    @peer.tk_pathname.should == '.tk::text0.tk::text1'
  end

  it 'lists the peer' do
    text.peer_names.should == ['.tk::text0.tk::text1']
  end

  it 'destroys the peer' do
    @peer.destroy
    text.peer_names.should == []
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
      text.search("et", '1.0').should == ['1.13']
      text.search("labore", '1.0').should == ['20.17']
    end

    it 'searches by regular expression' do
      text.search(/e[t]/, '1.0').should == ['1.13']
      text.search(/E[T]/i, '1.0').should == ['1.13']
      text.search(/DOLORE\.\nEA/i, '1.0').should == ['1.240']
    end

    it 'searches with regexp and switches' do
      text.search(/DOLORE\..EA/i, '1.0', :nolinestop).should == ['1.240']
    end

    it 'searches with :count' do
      text.search('et', '1.0', :count).should == ['1.13', 2]
      text.search('velit', '1.0', :all, :count).should == [['6.134', 5], ['20.168', 5]]
    end
  end

  # TODO: image handling
end