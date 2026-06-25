class StyleBuilder
  def initialize
    @rules = []
  end

  def self.build(&block)
    builder = new
    block.call(builder)
    builder.to_css
  end

  def rule(selector, **properties)
    properties = properties.map do |key, value|
      key = key.to_s.gsub("_", "-")
      value = value.to_s.gsub("_", "-")
      " #{key}: #{value};"
    end.join("\n")
    
    @rules << "#{selector} {\n#{properties}\n}"

  end

  def media(condition, &block)
    builder = StyleBuilder.new
    block.call(builder)
    inner_css_string = builder.to_css.split("\n").map { |line| "  #{line}" }.join("\n")
    
    @rules << "@media (#{condition}) {\n#{inner_css_string}\n}"
  end

  def to_css
    @rules.join("\n")
  end
end