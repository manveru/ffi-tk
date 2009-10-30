module Tk
  Event = Struct.new(:ev_id, :ev_seq, :border_width, :button, :count, :detail,
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
    @callback = %(bind %s <%s> { ::RubyFFI::event %d %s #@meta_string })
    @store = []
    @mutex = Mutex.new

    def self.handle(ev_id, ev_seq, *properties)
      event = new(ev_id.to_i, ev_seq.to_s)

      PROPERTIES.each do |code, conv, name|
        property = properties.shift
        next if property == '??'
        converted = __send__(conv, property)
        event[name] = converted
      end

      event.invoke
    end

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
      id
    end

    # Generates a window event and arranges for it to be processed just as if it
    # had come from the window system.
    # Window gives the path name of the window for which the event will be
    # generated; it may also be an identifier (such as returned by winfo id) as
    # long as it is for a window in the current application.
    # Event provides a basic description of the event, such as <Shift-Button-2>
    # or <<Paste>>.
    # If Window is empty the whole screen is meant, and coordinates are relative
    # to the screen.
    # Event may have any of the forms allowed for the sequence argument of the
    # bind command except that it must consist of a single event pattern, not a
    # sequence.
    # Option-value pairs may be used to specify additional attributes of the
    # event, such as the x and y mouse position; see EVENT FIELDS below.
    # If the -when option is not specified, the event is processed immediately:
    # all of the handlers for the event will complete before the event generate
    # command returns.
    # If the -when option is specified then it determines when the event is
    # processed.
    # Certain events, such as key events, require that the window has focus to
    # receive the event properly.
    def self.generate(path, event, options = {})
      path = path.tk_pathname if path.respond_to?(:tk_pathname)
      Tk.execute_only('event', 'generate', path, "<#{event}>", options)
    end

    def invoke
      Event.invoke(ev_id, self) if ev_id
    end
  end
end