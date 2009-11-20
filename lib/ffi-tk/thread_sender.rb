class ThreadSender
  def initialize
    @queue = Queue.new
    @thread = Thread.new{ reaper }
  end

  def reaper
    loop do
      block, response_queue = *@queue.pop
      response_queue.push(block.call)
    end
  end

  # If callbacks are invoked within a thread_send, we process them inside the
  # same thread.
  # Calling pop on the queue would cause deadlocks.
  def thread_send
    if @thread == Thread.current
      yield
    else
      response_queue = Queue.new
      @queue.push([Proc.new, response_queue])
      response_queue.pop
    end
  end
end
