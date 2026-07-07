# frozen_string_literal: true

require_relative '../../helper'

# Name-completeness guardrail: a widget's live options and its declared Option
# schema must line up, so cget/configure never meet an option with no declared
# type (which would raise Tk::UnknownOptionType at runtime).
#
# Two properties are checked against the running Tk, both here for the pilot
# widget Tk::Entry (Phase B extends this file to every instantiable widget):
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
  it 'Tk::Entry: every live option is declared; surplus only from the standard set' do
    entry =
      begin
        Tk::Entry.new
      rescue StandardError => e
        SpecHelper.skipped << "Tk::Entry guardrail skipped: #{e.class}: #{e.message}"
        next
      end

    declared = Tk::Entry.option_schema.names
    live = entry.configure.keys

    # completeness: no real option lacks a declared type.
    (live - declared).should == []

    # soundness: any name the schema has but the widget does not must be a
    # member of the shared standard-options dictionary, not a stray declaration.
    standard = Tk::Option::Standard::CLASSIC.names
    (declared - live).each do |surplus|
      standard.should.include surplus
    end
  end
end
