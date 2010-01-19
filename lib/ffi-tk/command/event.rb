module Tk
  # Miscellaneous event facilities: define virtual events and generate events
  #
  # The event command provides several facilities for dealing with window system
  # events, such as defining virtual events and synthesizing events.
  #
  # Please note that virtual event means events that are generated inside the
  # application and are written as "<<virtual>>", where virtual is the name of the
  # event.
  #
  # Sequences are names for single keys, or key combinations, also various other
  # actions create events, such as <MouseWheel> or <Destroy>.
  # A sequence is written as "<Control-Alt-Delete>", so only one enclosing <>
  # pair to distinguish them from virtual events.
  module Event
    # Associates the virtual event virtual with the physical event sequence(s)
    # given by the sequence arguments, so that the virtual event will trigger
    # whenever any one of the sequences occurs.
    # Virtual may be any string value and sequence may have any of the values
    # allowed for the sequence argument to the bind command.
    # If virtual is already defined, the new physical event sequences add to the
    # existing sequences for the event.
    def self.add(virtual, *sequences)
      Tk.execute_only(:event, :add, virtual, *sequences)
    end

    # Deletes each of the sequences from those associated with the virtual event
    # given by virtual.
    # Virtual may be any string value and sequence may have any of the values
    # allowed for the sequence argument to the bind command.
    # Any sequences not currently associated with virtual are ignored.
    # If no sequence argument is provided, all physical event sequences are
    # removed for virtual, so that the virtual event will not trigger anymore.
    def self.delete(virtual, *sequences)
      Tk.execute_only(:event, :delete, virtual, *sequences)
    end

    # Generates a window event and arranges for it to be processed just as if it
    # had come from the window system.
    # +window+ gives the path name of the window for which the event will be
    # generated; it may also be an identifier (such as returned by winfo id) as
    # long as it is for a window in the current application.
    # Event provides a basic description of the event, such as <Shift-Button-2>
    # or <<Paste>>.
    # If +window+ is empty the whole screen is meant, and coordinates are
    # relative to the screen.
    # Event may have any of the forms allowed for the sequence argument of the
    # bind command except that it must consist of a single event pattern, not a
    # sequence.
    #
    # +options+ may be used to specify additional attributes of the event, such
    # as the x and y mouse position.
    # See the documentation of [EventData] for a comprehensive list.
    #
    # If the :when option is not specified, the event is processed immediately:
    # all of the handlers for the event will complete before the event generate
    # command returns
    #
    # If the :when option is specified then it determines when the event is
    # processed. Certain events, such as key events, require that the window has
    # focus to receive the event properly.
    def self.generate(window = None, event = None, options = {})
      Tk.execute_only(:event, :generate, window, event, options.to_tcl_options)
    end

    # Returns information about virtual events.
    # If the <<virtual>> argument is omitted, the return value is a list of all
    # the virtual events that are currently defined.
    #
    # If <<virtual>> is specified then the return value is a list whose elements
    # are the physical event sequences currently defined for the given virtual
    # event; if the virtual event is not defined then an empty string is
    # returned. Note that virtual events that that are not bound to physical
    # event sequences are not returned by event info.
    def self.info(virtual = None)
      Tk.execute(:event, :info, virtual).to_a
    end
  end
end
