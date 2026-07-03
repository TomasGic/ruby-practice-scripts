RSpec.describe PageBuilder do
  # Initialize the superclass directly!
  let(:page) { PageBuilder.new(title: "Test Page") }

  describe "#initialize" do
    it "assigns the core attributes correctly" do
      expect(page.title).to eq("Test Page")
      expect(page.lang).to eq("en")
    end
  end

  describe "#build" do
    it "yields the block and passes arguments to HtmlBuilder" do
      allow(HtmlBuilder).to receive(:html_document).and_return("<html>page_content</html>")

      result = page.build { "<h1>Hello World</h1>" }

      # Note: stylesheets maps to "/styles/builder.css" because class name is PageBuilder
      expect(HtmlBuilder).to have_received(:html_document).with(
        title: "Test Page",
        lang: "en",
        stylesheets: ["/styles/builder.css"] 
      )
      expect(result).to eq("<html>page_content</html>")
    end
  end

  describe "#build_styles" do
    it "compiles the global base styles cleanly" do
      compiled_css = page.build_styles

      # Verifies that base styles work completely in a vacuum
      expect(compiled_css).to include("box-sizing: border-box")
      expect(compiled_css).to include("background-color: #1e1e2e")
      expect(compiled_css).to include("display: block")
    end
  end

  describe "private methods" do
    describe "#stylesheet_name" do
      it "extracts 'builder' from the PageBuilder class name" do
        expect(page.send(:stylesheet_name)).to eq("builder")
      end
    end
  end
end