class ThreadSender
  def initialize
    @queue = Queue.new
    
    @thread = Thread.new do
      loop do
        block, response_queue = *@queue.pop
        response_queue.push(block.call)
      end
    end
  end
  
  def thread_send(&block)
    response_queue = Queue.new
    @queue.push([block, response_queue])
    response_queue.pop
  end
end
  
ts = ThreadSender.new

ts.thread_send do
  puts "testing 1: #{Thread.current.inspect}"
end

ts.thread_send do
  puts "testing 2: #{Thread.current.inspect}"
end

puts Thread.current.inspect
nil
