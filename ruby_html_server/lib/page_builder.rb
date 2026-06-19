class PageBuilder
  attr_reader :title, :lang

  def initialize(title:, lang: "en")
    @title = title
    @lang = lang
  end

  def build(&block)
    styles = build_styles #this returns a raw css string, but should perhaps return a css file path?
    body_content = block.call(self) #clarify how the build method will be called with a block exactly
    #Does self represent the instance of PageBuilder class?
    #Why do we pass self as an argument to the block?

    HtmlBuilder.html_document(title: title, lang: lang, stylesheets: [styles]) do
      body_content
    end
  end

  private

  def build_styles
    StyleBuilder.build do |css|
      base_styles(css)
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