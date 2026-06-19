require_relative "html_builder"
require_relative "style_builder"

class PageBuilder
  include HtmlBuilder
  attr_reader :title, :lang

  def initialize(title:, lang: "en")
    @title = title
    @lang = lang
  end

  def build(&block)
    styles = build_styles #this returns a raw css string, but should perhaps return a css file path?
    body_content = block.call(self) #why do we pass self as argument to the block?
    HtmlBuilder.html_document(title: title, lang: lang, stylesheets: [styles]) do #why do we write title and not @title?
      body_content
    end
  end

  private

  def build_styles
    StyleBuilder.build do |css|
      base_styles(css) # should we add page_specific_styles method here?
    end
  end

  def base_styles(css)
    css.rule("*, *::before, *::after", box_sizing: "border-box")
    css.rule("body",
      margin: "0",
      font_family: "system-ui, -apple-system, sans-serif",
      line_height: "1.6",
      color: "#1a1a1a",
      background_color: "#fafafa"
    )
    css.rule("img", max_width: "100%", height: "auto", display: "block")
  end
end