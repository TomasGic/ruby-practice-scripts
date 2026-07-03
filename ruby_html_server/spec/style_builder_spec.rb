RSpec.describe StyleBuilder do
  describe ".build" do
    it "generates a simple CSS rule" do
      css = StyleBuilder.build do |s|
        s.rule("body", margin: "0")
      end
      expect(css).to include("body")
      expect(css).to include("margin: 0;")
    end

    it "converts underscored property names to hyphenated CSS" do
      css = StyleBuilder.build do |s|
        s.rule("p", font_size: "1rem", line_height: "1.6")
      end
      expect(css).to include("font-size: 1rem;")
      expect(css).to include("line-height: 1.6;")
    end

    it "supports media queries" do
      css = StyleBuilder.build do |s|
        s.rule("body", font_size: "1rem")
        s.media("min-width: 768px") do |mq|
          mq.rule("body", font_size: "1.125rem")
        end
      end
      expect(css).to include("@media (min-width: 768px)")
      expect(css).to include("font-size: 1.125rem;")
    end

    it "handles multiple rules" do
      css = StyleBuilder.build do |s|
        s.rule("h1", color: "blue")
        s.rule("h2", color: "green")
      end
      expect(css).to include("h1")
      expect(css).to include("h2")
    end
  end
end