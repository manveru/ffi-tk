# frozen_string_literal: true

module Tk
  class Root < Toplevel
    # The root window '.' already exists in Tk; unlike other widgets it is not
    # created, so the normal Widget initialisation is intentionally skipped.
    def initialize # rubocop:disable Lint/MissingSuper
      @tk_parent = nil
      @tk_pathname = '.'
    end
  end
end
