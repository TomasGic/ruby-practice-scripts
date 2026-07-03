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
    css_path = "/styles/#{stylesheet_name}.css"
    body_content = block.call 
    HtmlBuilder.html_document(title: title, lang: lang, stylesheets: [css_path]) do
      body_content
    end
  end

  def build_styles
    StyleBuilder.build do |css|
      base_styles(css)
      page_specific_styles(css)
    end
  end 

  private

  def stylesheet_name
    self.class.name.downcase.gsub("page", "")
  end

  def base_styles(css)
    css.rule("*, *::before, *::after", box_sizing: "border-box")
    css.rule("body",
      margin: "0",
      font_family: "system-ui, -apple-system, sans-serif",
      line_height: "1.6",
      color: "#b9bec8",
      background_color: "#1e1e2e"
    )
    css.rule("img", max_width: "100%", height: "auto", display: "block")
  end

  def page_specific_styles(css)
  end
end