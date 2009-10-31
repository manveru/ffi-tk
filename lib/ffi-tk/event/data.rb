module Tk
  module Event
    Data = Struct.new(
      :id, :sequence, :border_width, :button, :count, :detail, :focus, :height,
      :keycode, :keysym, :keysym_number, :mode, :mousewheel_delta,
      :override_redirect, :place, :property, :root, :send_event, :serial, :state,
      :subwindow, :time, :type, :unicode, :width, :window, :window_path, :x,
      :x_root, :y, :y_root
    )

    class Data
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

      def initialize(id, sequence, *properties)
        super id, sequence

        PROPERTIES.each do |code, conv, name|
          property = properties.shift
          next if property == '??'
          converted = __send__(conv, property)
          self[name] = converted
        end
      end

      def call
        Handler.invoke(id, self) if id
      end
    end
  end
end