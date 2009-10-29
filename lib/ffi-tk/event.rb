module Tk
  Event = Struct.new(:ev_id, :ev_bind, :border_width, :button, :count, :detail,
                     :focus, :height, :keycode, :keysym, :keysym_number, :mode,
                     :mousewheel_delta, :override_redirect, :place, :property,
                     :root, :send_event, :serial, :state, :subwindow, :time,
                     :type, :unicode, :width, :window, :window_path, :x, :x_root,
                     :y, :y_root)

  class Event
    PROPERTIES = [
      ['%#', :Integer, :serial            ],
      ['%b', :Integer, :button            ],
      ['%c', :Integer, :count             ],
      ['%d', :String,  :detail            ],
      ['%f', :String,  :focus             ],
      ['%h', :Integer, :height            ],
      ['%i', :String,  :window            ],
      ['%k', :String,  :keycode           ],
      ['%m', :String,  :mode              ],
      ['%o', :String,  :override_redirect ],
      ['%p', :String,  :place             ],
      ['%s', :String,  :state             ],
      ['%t', :String,  :time              ],
      ['%w', :Integer, :width             ],
      ['%x', :Integer, :x                 ],
      ['%y', :Integer, :y                 ],
      ['%A', :String,  :unicode           ],
      ['%B', :Integer, :border_width      ],
      ['%D', :String,  :mousewheel_delta  ],
      ['%E', :String,  :send_event        ],
      ['%K', :String,  :keysym            ],
      ['%N', :String,  :keysym_number     ],
      ['%P', :String,  :property          ],
      ['%R', :Integer, :root              ],
      ['%S', :Integer, :subwindow         ],
      ['%T', :Integer, :type              ],
      ['%W', :String,  :window_path       ],
      ['%X', :Integer, :x_root            ],
      ['%Y', :Integer, :y_root            ],
    ]

    @meta_string = PROPERTIES.transpose[0].join(' ').gsub(/%/, '%%')
    @callback = "bind %s <%s> { ::RubyFFI::store_event {%d %s #@meta_string}}"
    @store = []
    @mutex = Mutex.new

    def self.invoke(id, event)
      return unless found = @store.at(id)
      found.call(event)
    end

    def self.register(&block)
      id = nil

      @mutex.synchronize{
        @store << block
        id = @store.size - 1
      }

      return id
    end

    def self.register_in_tk(tag, sequence, &block)
      id = register(&block)
      Tk.interp.eval(@callback % [tag, sequence, id, sequence])
    end

    def invoke
      Event.invoke(ev_id, self) if ev_id
    end
  end
end