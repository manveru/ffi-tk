# frozen_string_literal: true
module Tk
  # Wait for variable to change or window to be destroyed
  #
  # This module provides blocking calls that wait for one of several things to
  # happen, then return without taking any other actions.
  #
  # The tkwait command waits for one of several things to happen, then it
  # returns without taking any other actions.
  # The return value is always nil.
  #
  # While the methods are waiting, events are processed in the normal fashion,
  # so the application will continue to respond to user interactions.
  # If an event handler invokes [Wait] methods again, the nested call must
  # complete before the outer call can complete.
  module Wait
    module_function

    # Waits for the variable called +name+ to be modified.
    def variable(name)
      Tk.execute_only(:tkwait, :variable, name)
    end

    # Takes the +name+ of a window and waits for a change in its visibility
    # state (as indicated by the arrival of a VisibilityNotify event).
    # Typically used to wait for a newly-created window to appear on the screen
    # before taking some action.
    def visibility(name)
      Tk.execute_only(:tkwait, :visibility, name)
    end

    # This method takes the name of a window as argument and waits until the
    # window is destroyed.
    # It is typically used to wait for a user to finish interacting with a
    # dialog box before using the result of that interaction.
    def window(name)
      Tk.execute_only(:tkwait, :window, name)
    end
  end
end
