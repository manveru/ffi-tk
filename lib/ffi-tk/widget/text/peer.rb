# frozen_string_literal: true

module Tk
  class Text
    # A text widget sharing another text widget's underlying content.
    # Created via Tk's `text peer create`.
    class Peer < Text
      # A peer is created via Tk's `peer create`, not the normal widget path,
      # so the standard Widget initialisation is intentionally skipped.
      def initialize(tk_parent, options = {}) # rubocop:disable Lint/MissingSuper
        @tk_parent = tk_parent
        Tk.execute(tk_parent.tk_pathname, 'peer', 'create', assign_pathname, options)
      end
    end
  end
end
