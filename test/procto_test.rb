# frozen_string_literal: true

require 'test_helper'

class ProctoTest < Minitest::Test
  def test_basic_call_functionality
    greeter_class = Class.new do
      include Procto.call

      def initialize(name)
        @name = name
      end

      def call
        "Hello, #{@name}!"
      end
    end

    result = greeter_class.call('Alice')
    assert_equal 'Hello, Alice!', result
  end

  def test_call_with_custom_method_name
    printer_class = Class.new do
      include Procto.call(:print)

      def initialize(message)
        @message = message
      end

      def print
        "Printing: #{@message}"
      end
    end

    # Should work with .call
    result = printer_class.call('test message')
    assert_equal 'Printing: test message', result

    # Should also work with the custom method name
    result = printer_class.print('test message')
    assert_equal 'Printing: test message', result
  end

  def test_call_with_symbol_method_name
    calculator_class = Class.new do
      include Procto.call(:compute)

      def initialize(a, b)
        @a = a
        @b = b
      end

      def compute
        @a + @b
      end
    end

    result = calculator_class.call(5, 3)
    assert_equal 8, result

    result = calculator_class.compute(10, 7)
    assert_equal 17, result
  end

  def test_call_with_string_method_name_converts_to_symbol
    formatter_class = Class.new do
      include Procto.call('format')

      def initialize(text)
        @text = text
      end

      def format
        @text.upcase
      end
    end

    result = formatter_class.call('hello')
    assert_equal 'HELLO', result

    result = formatter_class.format('world')
    assert_equal 'WORLD', result
  end

  def test_to_proc_returns_lambda
    doubler_class = Class.new do
      include Procto.call

      def initialize(number)
        @number = number
      end

      def call
        @number * 2
      end
    end

    proc_obj = doubler_class.to_proc
    assert proc_obj.lambda?
    
    result = proc_obj.call(5)
    assert_equal 10, result
  end

  def test_to_proc_works_with_map
    uppercaser_class = Class.new do
      include Procto.call

      def initialize(word)
        @word = word
      end

      def call
        @word.upcase
      end
    end

    words = %w[hello world ruby]
    result = words.map(&uppercaser_class)
    assert_equal %w[HELLO WORLD RUBY], result
  end

  def test_to_proc_works_with_custom_method_name
    reverser_class = Class.new do
      include Procto.call(:reverse_it)

      def initialize(text)
        @text = text
      end

      def reverse_it
        @text.reverse
      end
    end

    words = %w[hello world]
    result = words.map(&reverser_class)
    assert_equal %w[olleh dlrow], result
  end

  def test_multiple_arguments
    adder_class = Class.new do
      include Procto.call

      def initialize(a, b, c = 0)
        @a = a
        @b = b
        @c = c
      end

      def call
        @a + @b + @c
      end
    end

    result = adder_class.call(1, 2)
    assert_equal 3, result

    result = adder_class.call(1, 2, 3)
    assert_equal 6, result
  end

  def test_keyword_arguments
    multiplier_class = Class.new do
      include Procto.call

      def initialize(base:, factor: 1)
        @base = base
        @factor = factor
      end

      def call
        @base * @factor
      end
    end

    result = multiplier_class.call(base: 10)
    assert_equal 10, result

    result = multiplier_class.call(base: 10, factor: 3)
    assert_equal 30, result
  end

  def test_block_arguments
    block_processor_class = Class.new do
      include Procto.call

      def initialize(items, &block)
        @items = items
        @block = block
      end

      def call
        @items.map(&@block)
      end
    end

    result = block_processor_class.call([1, 2, 3]) { |n| n * 2 }
    assert_equal [2, 4, 6], result
  end

  def test_returns_same_instance_for_same_method_name
    module1 = Procto.call
    module2 = Procto.call
    
    # Should create new instances each time (since it's a factory)
    refute_equal module1.object_id, module2.object_id
  end

  def test_default_method_name_is_call
    test_class = Class.new do
      include Procto.call

      def initialize(value)
        @value = value
      end

      def call
        @value.to_s
      end
    end

    # Should define a .call method
    assert test_class.respond_to?(:call)
    
    result = test_class.call(42)
    assert_equal '42', result
  end

  def test_custom_method_name_creates_both_call_and_named_method
    test_class = Class.new do
      include Procto.call(:process)

      def initialize(data)
        @data = data
      end

      def process
        @data.reverse
      end
    end

    # Should define both .call and .process methods
    assert test_class.respond_to?(:call)
    assert test_class.respond_to?(:process)

    result1 = test_class.call('hello')
    result2 = test_class.process('hello')
    
    assert_equal 'olleh', result1
    assert_equal 'olleh', result2
  end

  def test_when_custom_method_name_is_call_only_defines_call
    test_class = Class.new do
      include Procto.call(:call)

      def initialize(value)
        @value = value
      end

      def call
        "processed: #{@value}"
      end
    end

    assert test_class.respond_to?(:call)
    
    result = test_class.call('test')
    assert_equal 'processed: test', result
  end

  def test_error_when_target_method_does_not_exist
    error_class = Class.new do
      include Procto.call(:nonexistent)

      def initialize(value)
        @value = value
      end

      # Note: we intentionally don't define the 'nonexistent' method
    end

    assert_raises(NoMethodError) do
      error_class.call('test')
    end
  end

  def test_complex_example_with_state
    counter_class = Class.new do
      include Procto.call(:increment)

      def initialize(start = 0, step = 1)
        @count = start
        @step = step
      end

      def increment
        @count += @step
      end
    end

    # Each call creates a new instance, so state is not shared
    result1 = counter_class.call
    assert_equal 1, result1

    result2 = counter_class.call(10, 5)
    assert_equal 15, result2

    result3 = counter_class.increment(100, 2)
    assert_equal 102, result3
  end
end
