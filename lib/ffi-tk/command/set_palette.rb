# frozen_string_literal: true
module Tk
  def self.set_palette(background, *rest)
    if rest.empty?
      Tk.execute(:tk_setPalette, background)
    else
      Tk.execute(:tk_setPalette, background, *rest)
    end
  end
end
