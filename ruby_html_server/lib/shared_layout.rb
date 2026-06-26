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
      HtmlBuilder.content_tag(:p, content: "&copy; 2026 Tomas. Built with pure Ruby.")
    end
  end
end