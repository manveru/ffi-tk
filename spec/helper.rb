# frozen_string_literal: true

# Each spec runs in its own process (see tasks/bacon.rake / tasks/coverage.rake).
# When COVERAGE is set, start SimpleCov before ffi-tk loads so every require is
# tracked, and give each process a unique command_name so results merge instead
# of overwriting one another.
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    command_name "spec-#{$PROGRAM_NAME}-#{Process.pid}"
    track_files 'lib/**/*.rb'
    add_filter '/spec/'
    merge_timeout 86_400
  end
end

require_relative '../lib/ffi-tk'
require 'bacon'

# Spec support kit, adapted from CPython's Lib/test/test_tkinter/support.py.
# Real Tk, no mocking; the environment is engineered for testability instead:
#   - per-spec isolation (destroy child widgets between specs),
#   - skip (not fail) mapping-dependent specs when no window manager maps them,
#   - a Tk-version gate and a Tcl-tolerant comparator for value assertions.
module SpecHelper
  module_function

  # Destroy every child widget of the root so state does not leak between specs.
  # winfo_children returns pathname strings, so destroy by path.
  def reset_root!
    Tk.root.winfo_children.each { |path| Tk.execute_only('destroy', path) }
  rescue StandardError => e
    warn "reset_root! failed: #{e.class}: #{e.message}"
  end

  # Running Tk patchlevel as [major, minor, patch], e.g. [8, 6, 16].
  def tk_patchlevel
    @tk_patchlevel ||= Tk.execute('info', 'patchlevel').to_s.split('.').map(&:to_i)
  end

  # True when the running Tk is at least the given version, e.g. requires_tk?(8, 7).
  def requires_tk?(*version)
    (tk_patchlevel <=> version) >= 0
  end

  # Poll until +widget+ is actually mapped by the window manager (realized with a
  # non-trivial size) or +timeout+ elapses. Never blocks forever, so it is safe
  # under a tiling/absent WM. Mirrors tkinter's wait_until_mapped.
  def mapped?(widget, timeout: 1.0)
    deadline = Time.now + timeout
    loop do
      Tk.execute('update')
      return true if widget.winfo_ismapped && widget.winfo_width > 1 && widget.winfo_height > 1
      return false if Time.now >= deadline

      sleep 0.01
    end
  end

  # Use as `next unless skip_unless_mapped(w)` inside an `it` block: proceeds when
  # the widget is mapped, otherwise records a skip and signals the block to bail
  # (so realized-geometry assertions do not fail on a headless/WM-less box).
  def skip_unless_mapped(widget, timeout: 1.0)
    return true if mapped?(widget, timeout: timeout)

    SpecHelper.skipped << caller_locations(1, 1).first.to_s
    false
  end

  # Tolerant comparison for Tcl return values: stringify scalars, compare arrays
  # element-wise. Handles [10] vs ["10"], symbol vs string, etc.
  def tcl_eq(actual, expected)
    return true if actual == expected
    return actual.to_s == expected.to_s unless actual.is_a?(Array) || expected.is_a?(Array)
    return false unless actual.is_a?(Array) && expected.is_a?(Array)

    actual.size == expected.size && actual.zip(expected).all? { |a, e| tcl_eq(a, e) }
  end

  def skipped
    @skipped ||= []
  end
end

# Make the kit callable from inside `describe`/`it` blocks.
Bacon::Context.include(SpecHelper)

# Report any skipped mapping-dependent specs so headless runs are not silent.
Bacon.summary_at_exit
at_exit do
  skips = SpecHelper.skipped
  warn "# skipped #{skips.size} mapping-dependent requirement(s) (no window manager)" unless skips.empty?
end
