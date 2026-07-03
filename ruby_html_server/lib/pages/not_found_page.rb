class NotFoundPage < PageBuilder
  def initialize(path: nil)
    super(title: "404 - Not Found")
    @path = path
  end

  def render
    build do
      
      h1_heading = HtmlBuilder.content_tag(:h1, content: "404 - Not Found")
      paragraph = HtmlBuilder.content_tag(
      :p, 
      content: "Sorry, the content you've requested at #{@path} does not exist or has been moved."
      )
      button = HtmlBuilder.content_tag(:a, content: "Go back to the home page", href: "/", class: "home-btn")

      HtmlBuilder.content_tag(:div, class: "not-found-container") do
        "#{h1_heading}\n#{paragraph}#{button}"
      end

      
    end
  end

  def page_specific_styles(css)
    css.rule(".not-found-container", text_align: "center", background_color: "#334155", padding: "1.5rem 2.5rem", max_width: "90%", margin: "3rem auto 0", border_radius: "2px")
    css.rule(".home-btn", padding: "0.8rem 2.4rem", cursor: "pointer", border_radius: "4px", color: "#334155", background_color: "#f0f0f0", border: "1px solid #f1f5f9", transition: "all 0.3s ease", text_decoration: "none", display: "inline-block", margin_top: "1rem", font_weight: "500")
    css.media("min-width: 768px") do |mq|
      mq.rule(".not-found-container", max_width: "60%")
    end
  end
end