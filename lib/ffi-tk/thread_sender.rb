# frozen_string_literal: true

# Runs blocks on one dedicated thread so every Tcl call shares a single OS thread.
#
# Exceptions raised by a block are re-raised in the thread that sent it. A
# Ruby callback that raises during a Tcl call has its exception re-raised by
# FFI when that call returns, i.e. inside a block here, so this is how callback
# errors reach the caller instead of silently killing the Tcl thread.
class ThreadSender
  # What a block produced: its value, or the exception it raised.
  Outcome = Data.define(:value, :error) do
    def unwrap
      raise error if error

      value
    end
  end

  def initialize
    @queue = Queue.new
    @thread = Thread.new { reaper }
  end

  def reaper
    loop do
      block, @response_queue = *@queue.pop
      @response_queue.push(run(block))
    end
  ensure
    # Only reached when an exception run cannot forward (SystemExit, a
    # signal) ends this thread; wake the waiting sender so it can re-raise it.
    @response_queue&.close
    @queue.close
  end

  # If callbacks are invoked within a thread_send, we process them inside the
  # same thread.
  # Calling pop on the queue would cause deadlocks.
  def thread_send(&block)
    return yield if @thread == Thread.current

    response_queue = Queue.new
    @queue.push([block, response_queue])
    outcome = response_queue.pop
    return outcome.unwrap if outcome

    @thread.join # re-raises whatever ended the Tcl thread
    raise ThreadError, 'the Tcl thread terminated'
  end

  private

  def run(block)
    Outcome.new(value: block.call, error: nil)
  rescue StandardError, ScriptError => e
    Outcome.new(value: nil, error: e)
  end
end
