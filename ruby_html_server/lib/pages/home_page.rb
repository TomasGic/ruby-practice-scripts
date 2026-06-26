require_relative '../shared_layout'

class HomePage < PageBuilder
  include SharedLayout
  
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
      "#{header_html}#{footer_html}"
    end
  end

  private

  def page_specific_styles(css)
    css.rule("body", background_color: "red", text_align: "center")
  end
end