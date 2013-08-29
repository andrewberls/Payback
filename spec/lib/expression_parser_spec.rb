require 'spec_helper'
require 'expression_parser'

def parse(expr)
  ExpressionParser.parse(expr)
end

describe ExpressionParser do
  it 'is indifferent to whitespace' do
    parse(' 2.5       + 2.5').should == 5
  end

  it 'strips invalid escape characters' do
    parse(" 1 \t   + 2\r\n").should == 3
  end

  it 'does not accept non-numeric values' do
    parse('a+b').should == 0
    parse('1+a').should == 1
    parse('1 + 1.5 + a').should == 2.5
  end

  it "accepts decimal values" do
    parse('2.5 + 2.25').should == 4.75
    parse('2.5 + -2.5').should == 0
    parse('5.79+2.2 + 3.55').should == 11.54
  end

  it 'accepts single values' do
    parse('2').should == 2
    parse('3.5').should == 3.5
  end
end
