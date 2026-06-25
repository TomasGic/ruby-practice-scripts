class HomePage < PageBuilder
  def initialize
    super(title: "Home page")
  end

  def build_styles
    StyleBuilder.build do |css|
      base_styles(css)
      page_specific_styles(css)
    end
  end

  def render
    build do
      heading = HtmlBuilder.content_tag(:h1, content: "Welcome to our home page")
      "#{heading}"
    end
  end

  private

  def page_specific_styles(css)
    css.rule(:body, background_color: "red", text_align: center)
  end
end