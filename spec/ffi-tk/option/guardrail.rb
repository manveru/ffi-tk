# frozen_string_literal: true

require_relative '../../helper'

# Name-completeness guardrail: a widget's live options and its declared Option
# schema must line up, so cget/configure never meet an option with no declared
# type (which would raise Tk::UnknownOptionType at runtime).
#
# Two properties are checked against the running Tk, for every instantiable
# widget that has been migrated to the Schema+Coercer path:
#
#   completeness - every option Tk actually reports IS declared. This is the
#                  property that matters: an undeclared-but-real option is a
#                  latent crash.
#   soundness    - the schema declares nothing the widget does not have, EXCEPT
#                  names carried by the shared standard-options dictionary a
#                  widget opts into wholesale (`classic_options`). That
#                  dictionary is a superset by design (options(3tk) lists every
#                  classic standard option; no single widget uses all of them),
#                  so a surplus name is only acceptable when it comes from there
#                  -- never from a widget_options/option_aliases typo.
describe 'option schema name-completeness guardrail' do
  classic_standard = Tk::Option::Standard::CLASSIC.names
  ttk_standard = Tk::Option::Standard::TTK.names

  # Every classic widget migrated in Phase B, keyed by its builder. Root reuses
  # the already-created '.' window and inherits Toplevel's schema unchanged.
  classic = {
    'Tk::Entry' => -> { Tk::Entry.new },
    'Tk::Button' => -> { Tk::Button.new },
    'Tk::CheckButton' => -> { Tk::CheckButton.new },
    'Tk::RadioButton' => -> { Tk::RadioButton.new },
    'Tk::MenuButton' => -> { Tk::MenuButton.new },
    'Tk::Label' => -> { Tk::Label.new },
    'Tk::Message' => -> { Tk::Message.new },
    'Tk::Frame' => -> { Tk::Frame.new },
    'Tk::LabelFrame' => -> { Tk::LabelFrame.new },
    'Tk::Toplevel' => -> { Tk::Toplevel.new },
    'Tk::Root' => -> { Tk.root },
    'Tk::Scale' => -> { Tk::Scale.new },
    'Tk::Scrollbar' => -> { Tk::Scrollbar.new },
    'Tk::Listbox' => -> { Tk::Listbox.new },
    'Tk::Spinbox' => -> { Tk::Spinbox.new },
    'Tk::Menu' => -> { Tk::Menu.new },
    'Tk::PanedWindow' => -> { Tk::PanedWindow.new },
    'Tk::Text' => -> { Tk::Text.new },
    'Tk::Canvas' => -> { Tk::Canvas.new }
  }

  # Every instantiable themed (ttk) widget migrated in Phase B4. The classic
  # subclassers (Tile::Entry < Tk::Entry, ...) override tk_command, so they
  # declare their own themed schema rather than inherit the classic parent's;
  # YScrollbar/XScrollbar inherit Tile::Scrollbar's tk_command unchanged and so
  # share its schema. Themed widgets opt into the ttk (not classic) standard
  # set, so their surplus is checked against that superset.
  tile = {
    'Tk::Tile::Entry' => -> { Tk::Tile::Entry.new },
    'Tk::Tile::Frame' => -> { Tk::Tile::Frame.new },
    'Tk::Tile::Button' => -> { Tk::Tile::Button.new },
    'Tk::Tile::LabelFrame' => -> { Tk::Tile::LabelFrame.new },
    'Tk::Tile::CheckButton' => -> { Tk::Tile::CheckButton.new },
    'Tk::Tile::RadioButton' => -> { Tk::Tile::RadioButton.new },
    'Tk::Tile::MenuButton' => -> { Tk::Tile::MenuButton.new },
    'Tk::Tile::PanedWindow' => -> { Tk::Tile::PanedWindow.new },
    'Tk::Tile::Label' => -> { Tk::Tile::Label.new },
    'Tk::Tile::Scale' => -> { Tk::Tile::Scale.new },
    'Tk::Tile::Scrollbar' => -> { Tk::Tile::Scrollbar.new },
    'Tk::Tile::YScrollbar' => -> { Tk::Tile::YScrollbar.new },
    'Tk::Tile::XScrollbar' => -> { Tk::Tile::XScrollbar.new },
    'Tk::Tile::Notebook' => -> { Tk::Tile::Notebook.new },
    'Tk::Tile::Separator' => -> { Tk::Tile::Separator.new },
    'Tk::Tile::Sizegrip' => -> { Tk::Tile::Sizegrip.new },
    'Tk::Tile::ComboBox' => -> { Tk::Tile::ComboBox.new },
    'Tk::Tile::Progressbar' => -> { Tk::Tile::Progressbar.new },
    'Tk::Tile::Treeview' => -> { Tk::Tile::Treeview.new }
  }

  cases = []
  classic.each { |name, build| cases << [name, build, classic_standard] }
  tile.each { |name, build| cases << [name, build, ttk_standard] }

  cases.each do |name, build, standard|
    it "#{name}: every live option is declared; surplus only from the standard set" do
      widget =
        begin
          build.call
        rescue StandardError => e
          SpecHelper.skipped << "#{name} guardrail skipped: #{e.class}: #{e.message}"
          next
        end

      declared = widget.class.option_schema.names
      live = widget.configure.keys

      # completeness: no real option lacks a declared type.
      (live - declared).should == []

      # soundness: any name the schema has but the widget does not must be a
      # member of the shared standard-options dictionary, not a stray declaration.
      (declared - live).each do |surplus|
        standard.should.include surplus
      end
    end
  end
end
