module ExpressionParser
  extend self

  # Sum extremely basic arithmetic strings
  # ex: ExpressionParse.parse("2.5 + 2.5") -> 5.0
  def parse(expr)
    tokens = expr.chomp.strip.split('+')
    tokens.map(&:to_f).inject(&:+)
  end

end
