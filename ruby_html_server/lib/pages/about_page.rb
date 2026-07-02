require_relative '../shared_layout'

class AboutPage < PageBuilder
  include SharedLayout

  def initialize
    super(title: "About page")
  end

  def build_styles
    StyleBuilder.build do |css|
      base_styles(css)
      page_specific_styles(css)
    end
  end

  def render
    build do
      profile_section = HtmlBuilder.content_tag(:section, id: "profile") do
        HtmlBuilder.content_tag(:h2, content: "About me") + 
        HtmlBuilder.content_tag(:p) do
          time_tag = HtmlBuilder.content_tag(:time, content: "April 2020", datetime: "2020-04")
          paragraph_content = <<~TEXT
            My programming journey began in #{time_tag} when the whole world shut down due to
            the covid pandemic.
          TEXT

          paragraph_content
        end
      end

      technologies_section = HtmlBuilder.content_tag(:section, id: "technologies") do
        HtmlBuilder.content_tag(:h2, content: "Skills & Technologies") +  
        HtmlBuilder.content_tag(:div, class: "table-container") do
          HtmlBuilder.table(
            headers: [
              "Technology",
              "Category",
              "Level",
              "Started",
              "Weekly hours",
              "Goal by"
            ],
            rows: [
              ["Ruby", "Language", "3", "January 5th 2026", "15", "Expert level (5)"],
              ["Python", "Language", "4", "June 2020", "5", "Expert level (5)"],
              ["Javascript", "Language", "4", "June 2020", "5", "Expert level (5)"],
              ["HTML", "Language", "3", "June 2020", "5", "Expert level (5)"],
              ["CSS", "Language", "3", "June 2020", "5", "Expert level (5)"],
              ["Git", "Tools/version control", "3", "January 5, 2026", "1", "Expert level (5)"]
            ],
            caption: "Current technology proficiency matrix"
          )
        end
      end

      blockquote = HtmlBuilder.content_tag(:figure) do
        HtmlBuilder.content_tag(:p, content: "The following is one of my favourite quotes whenever I feel stuck or want to give up.") + 
        HtmlBuilder.content_tag(:blockquote) do
          HtmlBuilder.content_tag(:p, content: "It always seems impossible until it's done.")
        end + 
        HtmlBuilder.content_tag(:figcaption, class: "quote-caption") do
          "&mdash; Nelson Mandela, via " + HtmlBuilder.content_tag(:cite, content: "BrainyQuote")
        end
      end

      "#{header_html}#{profile_section}#{technologies_section}#{blockquote}#{footer_html}"
    end
  end

  private
  
  def page_specific_styles(css)
    header_css(css)
    css.rule("#profile", margin: "0 auto", text_align: "center")
    css.rule("#technologies", text_align: "center", margin_top: "4rem")
    css.rule(".table-container", width: "100%", overflow_x: "auto")
    css.rule("table", border_collapse: "collapse", background_color: "#1e293b", margin: "0 auto")
    css.rule("th, td", padding: "0.9rem", text_align: "left", border_bottom: "1px solid #334155")
    css.rule("caption", margin_bottom: "1rem")
    css.rule("figure", text_align: "center", margin_top: "4rem")
    footer_css(css)
  end
end