require_relative 'html_builder'

module SharedLayout
  def header_html
    HtmlBuilder.content_tag(:header, class: "site-header") do
      HtmlBuilder.content_tag(:h1, content: "My Ruby Site") +
      HtmlBuilder.nav([
        { text: "Home", href: "/" },
        { text: "About", href: "/about" },
        { text: "Contact", href: "/contact" }
      ], aria_label: "Main navigation")
    end
  end

  def footer_html
    HtmlBuilder.content_tag(:footer, class: "site-footer") do
      HtmlBuilder.nav(
        [
          { text: "Home", href: "/" },
          { text: "About", href: "/about" },
          { text: "Contact", href: "/contact" }
        ],
        aria_label: "Footer navigation"
      ) + 
      HtmlBuilder.content_tag(:p, content: "&copy; 2026 Tomas. Built with pure Ruby.")
    end
  end

  def header_css(css)
    css.rule(
      "header",
      background_color: "#1e1e2e",
      color: "#b9bec8",
      padding: "2.5rem 1rem",
      text_align: "center"
    )
    css.rule("nav", display: "flex", gap: "2rem", justify_content: "center")
    css.rule("nav a", text_decoration: "none", color: "#b9bec8", text_transform: "uppercase", display: "inline-block")
  end

  def footer_css(css)
    css.rule("footer", background_color: "#1e1e2e", color: "#b9bec8", text_align: "center")
    css.rule("footer", padding: "3rem 1.5rem 0", margin_top: "2rem")
    css.rule("footer nav", display: "flex", justify_content: "center")
    css.rule("footer p", margin_top: "2rem")
  end
end