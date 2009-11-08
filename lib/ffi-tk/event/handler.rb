module Tk
  module Event
    module Handler
      data = Data::PROPERTIES.transpose[0].join(' ').gsub(/%/, '%%')
      @callback = %(bind %s %s { ::RubyFFI::event %d %s #{data} })
      @store = []
      @mutex = Mutex.new

      module_function

      def invoke(id, event)
        return unless found = @store.at(id)
        found.call(event)
      end

      def register_block(block)
        id = nil

        @mutex.synchronize{
          @store << block
          id = @store.size - 1
        }

        return id
      end

      def register(tag, sequence, &block)
        id = register_block(block)
        Tk.interp.eval(@callback % [tag, sequence, id, sequence])
        id
      end

      def register_custom(block)
        id = register_block(block)
        yield id
        id
      end

      def unregister(id)
        @store[id] = nil
      end
    end
  end
end
