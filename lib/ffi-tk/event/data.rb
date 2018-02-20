# frozen_string_literal: true
module Tk
  module Event
    Data = Struct.new(
      :id, :pattern, :border_width, :button, :count, :detail, :focus, :height,
      :keycode, :keysym, :keysym_number, :mode, :mousewheel_delta,
      :override_redirect, :place, :property, :root, :send_event, :serial,
      :state, :subwindow, :time, :type, :unicode, :width, :window,
      :window_path, :x, :x_root, :y, :y_root
    )

    class Data
      PROPERTIES = [
        ['%#', :Integer, :serial],
        ['%b', :Integer, :button],
        ['%c', :Integer, :count],
        ['%d', :String,  :detail],
        ['%f', :String,  :focus],
        ['%h', :Integer, :height],
        ['%i', :String,  :window],
        ['%k', :Integer, :keycode],
        ['%m', :String,  :mode],
        ['%o', :String,  :override_redirect],
        ['%p', :String,  :place],
        ['%s', :String,  :state],
        ['%t', :Integer, :time],
        ['%w', :Integer, :width],
        ['%x', :Integer, :x],
        ['%y', :Integer, :y],
        ['%A', :String,  :unicode],
        ['%B', :Integer, :border_width],
        ['%D', :Integer, :mousewheel_delta],
        ['%E', :Integer, :send_event],
        ['%K', :String,  :keysym],
        ['%N', :Integer, :keysym_number],
        ['%P', :String,  :property],
        ['%R', :String,  :root],
        ['%S', :String,  :subwindow],
        ['%T', :Integer, :type],
        ['%W', :String,  :window_path],
        ['%X', :Integer, :x_root],
        ['%Y', :Integer, :y_root]
      ].freeze

      def initialize(id, pattern, *properties)
        super id, pattern

        PROPERTIES.each do |_code, conv, name|
          value = properties.shift
          converted = String(value)
          next if converted == '??'
          converted = __send__(conv, value)
          self[name] = converted
        end
      end

      def call
        Handler.invoke(id, self) if id
      end

      # Try to resend the event with as much information preserved as possible.
      # Unfortunately that doesn't seem to be easy.
      def resend(widget, virtual, changes = {})
        original = {}
        members.each do |name|
          value = self[name]

          case name
          when :id, :pattern, :border_width, :button, :count, :focus, :height,
            :keycode, :keysym, :keysym_number, :mode, :mousewheel_delta,
            :override_redirect, :place, :property, :root, :send_event,
            :subwindow, :type, :unicode, :width, :window, :window_path
          when :x_root
            original[:rootx] = value
          when :y_root
            original[:rooty] = value
          when :detail
            original[name] = value if value
          else
            original[name] = value
          end
        end

        Event.generate(widget, virtual, original.merge(changes))
      end

      def widget
        Tk.widgets[window_path]
      end

      def sequence
        Kernel.warn("#{self.class}.sequence deprecated, use #{self.class}.pattern")
        pattern
      end
    end
  end
end
