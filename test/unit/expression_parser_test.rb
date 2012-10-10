require File.expand_path('../../test_helper',  __FILE__)
require 'expression_parser'

def parse(expr)
  ExpressionParser.parse(expr)
end

class ExpressionParserTest < Test::Unit::TestCase
  context "expression parser" do
    should "be indifferent to whitespace" do
      assert_equal 5, parse(" 2.5       + 2.5")
    end

    should "strip invalid escape characters" do
      assert_equal 3, parse(" 1 \t   + 2\r\n")
    end

    should "not accept non-numeric values" do
      assert_equal 0, parse("a+b")
      assert_equal 1, parse("1+a")
      assert_equal 2.5, parse("1 + 1.5 + a")

      # assert_equal 0, parse("2.5 - 2.5")
    end

    should "work with decimal values" do
      assert_equal 4.75, parse("2.5 + 2.25")
      assert_equal 0, parse("2.5 + -2.5")
      assert_equal 11.54, parse("5.79+2.2 + 3.55")
    end

    should "still handle single values" do
      assert_equal 2, parse("2")
      assert_equal 3.5, parse("3.5")
    end

  end
end
