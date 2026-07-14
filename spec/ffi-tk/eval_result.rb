# frozen_string_literal: true

require_relative '../helper'

# Exercises the Tcl-object -> Ruby-value guesser in
# lib/ffi-tk/ffi/tcl/eval_result.rb end-to-end: every expression below produces
# a Tcl object of a known internal type, and we assert the class AND value of
# the Ruby it converts to. Because the results are self-evident by construction,
# absolute assertions are appropriate here.
#
# The guesser dispatches on the *internal representation* Tcl has assigned to the
# object, not on how the string looks. `expr` forces numeric types; a plain
# `set` leaves the object as a string until something coerces it. Several specs
# below pin down surprising-but-correct consequences of that.
describe FFI::Tcl::EvalResult do
  # Drive a Tcl expression all the way through the guesser and return the Ruby.
  # Tk.result == interp.guess_result == EvalResult.guess(...).
  def guess(expr)
    Tk.interp.eval(expr)
    Tk.result
  end

  # Build an EvalResult wrapping the current interpreter result, so the instance
  # converter methods (to_a, to_s?, to_boolean, ...) can be exercised directly.
  def eval_result(expr)
    interp = Tk.interp
    interp.eval(expr)
    FFI::Tcl::EvalResult.new(interp, FFI::Tcl::Obj.new(FFI::Tcl.get_obj_result(interp)))
  end

  # --- :int branch -> Integer ---------------------------------------------

  it 'converts an integer expr result to an Integer' do
    value = guess('expr 1 + 1')
    value.class.should == Integer
    value.should == 2
  end

  it 'converts a command that yields an integer (string length) to an Integer' do
    value = guess('string length hello')
    value.class.should == Integer
    value.should == 5
  end

  it 'converts a boolean expr result to Integer 1/0, not true/false' do
    guess('expr {1 == 1}').should == 1
    guess('expr {1 != 1}').should == 0
    guess('expr {1 == 1}').class.should == Integer
  end

  it 'parses a hex literal via expr to its Integer value' do
    guess('expr 0x10').should == 16
  end

  # Integer-typed values are converted through Tcl's wide (64-bit) int, so
  # values past the 32-bit boundary come back exact instead of wrapping.
  it 'converts integer-typed values past the 32-bit boundary without wrapping' do
    guess('expr {2147483647}').should == 2_147_483_647
    guess('expr {2147483648}').should == 2_147_483_648
    guess('expr {2147483648}').should == 2**31
  end

  it 'converts the largest 64-bit signed integer exactly' do
    guess('expr {9223372036854775807}').should == 9_223_372_036_854_775_807
    guess('expr {9223372036854775807}').should == (2**63) - 1
  end

  it 'converts a negative value below the 32-bit boundary without wrapping' do
    guess('expr {-2147483649}').should == -2_147_483_649
  end

  # --- :double branch -> Float --------------------------------------------

  it 'converts a floating-point expr result to a Float' do
    value = guess('expr 1.5')
    value.class.should == Float
    value.should == 1.5
  end

  it 'promotes mixed int/float arithmetic to a Float' do
    value = guess('expr 2 + 3.0')
    value.class.should == Float
    value.should == 5.0
  end

  it 'parses scientific notation via expr as a Float' do
    value = guess('expr 1e5')
    value.class.should == Float
    value.should == 100_000.0
  end

  # --- :list branch -> Array ----------------------------------------------

  it 'converts a Tcl list to an Array of Strings' do
    value = guess('list a b c')
    value.class.should == Array
    value.should == %w[a b c]
  end

  it 'recursively converts a nested Tcl list to nested Arrays' do
    value = guess('list [list a b] [list c d]')
    value.should == [%w[a b], %w[c d]]
  end

  it 'guesses element types inside a list (numbers stay strings without expr)' do
    # List elements are guessed with a :to_string fallback, so a bare "1" that
    # Tcl never numerically typed comes back as the String "1".
    guess('list 1 2 3').should == %w[1 2 3]
  end

  # --- :dict branch -> Hash -----------------------------------------------

  it 'converts a Tcl dict to a Hash with String keys and String values' do
    value = guess('dict create k v k2 v2')
    value.class.should == Hash
    value.should == { 'k' => 'v', 'k2' => 'v2' }
  end

  it 'iterates a multi-entry dict correctly through the search cursor' do
    guess('dict create a 1 b 2 c 3 d 4 e 5')
      .should == { 'a' => '1', 'b' => '2', 'c' => '3', 'd' => '4', 'e' => '5' }
  end

  # SURPRISE: dict values are pulled with get_string_from_obj, NOT re-guessed,
  # so a nested dict comes back as its flat string representation, not a Hash.
  it 'does not recursively convert dict values (nested dict stays a String)' do
    guess('dict create outer [dict create k v]').should == { 'outer' => 'k v' }
  end

  # --- :string / fallback branches -> String ------------------------------

  it 'converts a plain string result to a String' do
    value = guess('string range hello 0 2')
    value.class.should == String
    value.should == 'hel'
  end

  # SURPRISE: booleans are never auto-converted by the guesser; the words come
  # back as plain Strings. Only an explicit to_boolean coerces them.
  it 'leaves boolean-looking words as Strings' do
    guess('set x true').should == 'true'
    guess('set x false').should == 'false'
    guess('set x yes').should == 'yes'
    guess('set x true').class.should == String
  end

  # SURPRISE: a leading-zero number set (not expr'd) is never int-typed and so
  # keeps its literal String form, zeros intact.
  it 'keeps a leading-zero literal as a String' do
    guess('set x 007').should == '007'
  end

  # SURPRISE: `set x 3.0` is not double-typed until coerced, so it stays "3.0".
  it 'keeps a set (non-expr) decimal literal as a String' do
    guess('set x 3.0').should == '3.0'
  end

  it 'keeps a non-numeric token as a String' do
    guess('set x 123abc').should == '123abc'
  end

  # SURPRISE: an integer literal too big for expr to type stays a String, so it
  # is returned exactly (no truncation), unlike the int32-typed path above.
  it 'keeps an over-wide integer literal as an exact String' do
    guess('set x 12345678901234567890').should == '12345678901234567890'
  end

  it 'preserves a multibyte UTF-8 string' do
    value = guess('set x "héllo wörld"')
    value.should == 'héllo wörld'
    value.encoding.should == Encoding.default_external
  end

  it 'reports a window path (winfo class) as a String' do
    value = guess('winfo class .')
    value.class.should == String
  end

  # --- empty / nil fallback ------------------------------------------------

  it 'converts an empty result to nil' do
    guess('list').should.be.nil
    guess('string cat').should.be.nil
    guess('return -level 0 {}').should.be.nil
  end

  # --- :bytearray branch -> binary String ---------------------------------

  # Tcl bytearrays (produced by `binary format` etc.) convert to a binary
  # String carrying the exact bytes, in ASCII-8BIT encoding.
  it 'converts a Tcl bytearray result to a binary String' do
    value = guess('binary format a5 hello')
    value.class.should == String
    value.should == 'hello'
    value.encoding.should == Encoding::ASCII_8BIT
  end

  it 'preserves NUL and padding bytes in a bytearray (no UTF-8 mangling)' do
    # The \x00 is a Tcl escape (a literal NUL byte cannot ride through the
    # NUL-terminated eval script). a3 pads/truncates to 3 bytes; the leading NUL
    # must survive intact rather than becoming Tcl modified UTF-8 (0xC0 0x80).
    value = guess('binary format a3 "\x00ab"')
    value.bytes.should == [0, 97, 98]
    value.encoding.should == Encoding::ASCII_8BIT
  end

  # --- instance converter methods -----------------------------------------

  it 'to_a returns the list elements' do
    eval_result('list a b c').to_a.should == %w[a b c]
  end

  it 'to_a takes a block to transform elements' do
    eval_result('list 1 2 3').to_a(&:to_i).should == [1, 2, 3]
  end

  it 'to_a? returns the list, nil when empty' do
    eval_result('list a b').to_a?.should == %w[a b]
    eval_result('list').to_a?.should.be.nil
  end

  it 'to_s returns the flat string form of a list' do
    eval_result('list a b c').to_s.should == 'a b c'
  end

  it 'to_s? returns the string, nil when empty' do
    eval_result('set x hello').to_s?.should == 'hello'
    eval_result('set x {}').to_s?.should.be.nil
  end

  it 'to_sym symbolizes the string form' do
    eval_result('set x hello').to_sym.should == :hello
  end

  it 'to_sym? symbolizes the string form, nil when empty' do
    eval_result('set x hello').to_sym?.should == :hello
    eval_result('set x {}').to_sym?.should.be.nil
  end

  it 'to_i returns an Integer, and "" for an empty object (text -endline convention)' do
    eval_result('set x 42').to_i.should == 42
    eval_result('set x {}').to_i.should == ''
  end

  it 'to_f returns a Float' do
    value = eval_result('expr 1.25').to_f
    value.class.should == Float
    value.should == 1.25
  end

  it 'to_boolean coerces Tcl truth values to true/false' do
    eval_result('set x 1').to_boolean.should == true
    eval_result('set x 0').to_boolean.should == false
    eval_result('set x true').to_boolean.should == true
    eval_result('set x no').to_boolean.should == false
  end

  it 'to_tcl quotes the string form as a Tcl literal' do
    eval_result('set x hello').to_tcl.should == '"hello"'
  end

  it 'inspect wraps the string form' do
    eval_result('set x hello').inspect.should == '#<EvalResult hello>'
  end

  # A :window-typed result must resolve to the window's path-name string, not a
  # debug dump. (The :window internal type is unreachable via plain eval, so the
  # converter contract is exercised directly.)
  it 'to_window returns the window path-name string' do
    interp = Tk.interp
    interp.eval('set x .')
    obj = FFI::Tcl::Obj.new(FFI::Tcl.get_obj_result(interp))
    FFI::Tcl::EvalResult.to_window(interp, obj).should == '.'
  end
end
