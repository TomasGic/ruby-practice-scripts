require_relative '../shared_layout'

class HomePage < PageBuilder
  include SharedLayout
  
  def initialize
    super(title: "Home page")
  end

  def render
    build do
      hero_section = HtmlBuilder.content_tag(:div, class: "hero") do
        HtmlBuilder.content_tag(:h2, content: "My Web Development Journey") + 
        HtmlBuilder.content_tag(:p, content: "A personal dashboard tracking my journey from Ruby to full-stack development.")
      end
      skills_section = HtmlBuilder.content_tag(:section, id: "skills") do
          HtmlBuilder.content_tag(:h2, content: "My Skills") +
          HtmlBuilder.definition_list({
            "Ruby" => "Object-oriented scripting, building custom web servers, and automated template parsing.",
            "HTML5 & CSS3" => "Semantic layouts, programmatic styling, Flexbox alignment, and responsive design.",
            "Git & GitHub" => "Version control, branching strategies, and managing multi-directory script repositories."
          }, class: "skills-list")
        end

      milestones = [
        "Created my first github repo and made my first git commit.",
        "Wrote my first Ruby script.",
        "For the first time I analyzed my code in terms of its time complexity.",
        "Created my first OOP program in Ruby using Test Driven Development approach.",
        "Created my first web page only using HTML semantic elements."
      ]

      dates = ["2026-01-01", "2026-01-07", "2026-01-14", "2026-01-21", "2026-02-02"]

      milestones_list_items = milestones.zip(dates).map do |milestone, date|
        time_tag = HtmlBuilder.content_tag(:time, content: date, datetime: date)
        "#{time_tag} - #{milestone}"
      end

      milestones_section = HtmlBuilder.content_tag(:section, id: "milestones") do 
        HtmlBuilder.content_tag(:h2, content: "Recent Milestones") +
        HtmlBuilder.list(milestones_list_items, type: :ol)
      end
      
      #final html output
      "#{header_html}#{hero_section}#{skills_section}#{milestones_section}#{footer_html}"
    end
  end

  private

  def page_specific_styles(css)
    header_css(css)
    css.rule("body", background_color: "#1e1e2e", text_align: "center")
    css.rule(".hero", text_align: "center", margin_bottom: "4rem")
    css.rule("#skills", max_width: "800px", margin: "0 auto")
    css.rule("#skills h2", margin_bottom: "2rem")
    css.rule(".skills-list dt", font_weight: "700")
    css.rule(".skills-list dd", margin_bottom: "1.5rem", font_weight: "500")
    css.rule("#milestones ol", list_style: "none", text_align: "left", margin: "0 auto", max_width: "800px")
    css.rule("#milestones ol li", margin_bottom: "1rem")
    css.rule("#milestones h2", margin_bottom: "2rem")
    css.rule("time", font_weight: "600")
    css.media("min-width: 1024px") do |mq|
      mq.rule(".skills-list", display: "grid", grid_template_columns: "200px 1fr")
    end
    footer_css(css)
  end
end