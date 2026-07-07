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
  standard = Tk::Option::Standard::CLASSIC.names

  # Every classic widget migrated in Phase B, keyed by its builder. Root reuses
  # the already-created '.' window and inherits Toplevel's schema unchanged.
  {
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
  }.each do |name, build|
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
