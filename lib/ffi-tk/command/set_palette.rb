# frozen_string_literal: true

# Recolour the default widget palette (Tk's tk_setPalette).
module Tk
  def self.set_palette(background, *rest)
    if rest.empty?
      Tk.execute(:tk_setPalette, background)
    else
      Tk.execute(:tk_setPalette, background, *rest)
    end
  end
end
