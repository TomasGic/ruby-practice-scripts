require_relative '../shared_layout'

class ContactPage < PageBuilder
  include SharedLayout

  def initialize
    super(title: "Contact page")
  end

  def render
    build do

      fieldset1 =  HtmlBuilder.content_tag(:fieldset) do
        HtmlBuilder.content_tag(:legend, content: "Your Information") + 
        HtmlBuilder.content_tag(:div, class: "input-wrapper") do
          HtmlBuilder.labeled_input(label: "Full name (required)", id: "name", name: "email", minlength: "2", required: true)
        end + 
        HtmlBuilder.content_tag(:div, class: "input-wrapper") do
          HtmlBuilder.labeled_input(label: "Email (required)", type: "email", id: "email", name: "email", required: true)
        end + 
        HtmlBuilder.content_tag(:div, class: "input-wrapper") do
          HtmlBuilder.labeled_input(label: "Website (optional)", type: "url", id: "website", name: "website")
        end
      end

      fieldset2 = HtmlBuilder.content_tag(:fieldset) do
        select_values = ["mentoring", "collaboration", "feedback", "question", "other"]
        HtmlBuilder.content_tag(:legend, content: "Your Message") + 
        HtmlBuilder.content_tag(:div, class: "input-wrapper") do
          HtmlBuilder.labeled_select_input(values: select_values, label: "Subject", id: "subject", name: "subject", required: true) 
        end + 

        HtmlBuilder.content_tag(:div, class: "full-width input-wrapper") do
          HtmlBuilder.labeled_textarea_input(label: "Your message (required):", id: "message", name: "message", minlength: "20", maxlength: "2000", rows: "6", aria_describedby: "message-limit", required: true)
        end
      end

      buttons = HtmlBuilder.content_tag(:div, class: "btn-container") do
          HtmlBuilder.content_tag(:button, content: "Send Message", type: "submit") +
          HtmlBuilder.content_tag(:button, content: "Clear Form", type: "reset")
      end
      
      #final html output
      HtmlBuilder.content_tag(:section, id: "contact") do
        HtmlBuilder.content_tag(:h2, content: "Get in touch") + 
        HtmlBuilder.form(action: "/submit", method: "POST") do
          "#{fieldset1}#{fieldset2}#{buttons}"

        end
      end
    end
  end

  private

  def page_specific_styles(css)
    header_css(css)
    
    css.rule("#contact h2", text_align: "center")
    css.rule("form", margin: "0 auto", max_width: "800px")
    css.rule("fieldset", display: "grid", padding: "2.5rem 1.5rem", grid_template_columns: "minmax(0, 1fr)", gap: "1.5rem", border_radius: "10px", margin_bottom: "2rem")
    css.rule(".input-wrapper", display: "flex", flex_direction: "column", gap: "0.25rem", margin_bottom: "1.5rem")
    css.rule("legend", font_weight: "500", font_size: "1.2rem")
    css.rule("input, select, textarea", padding: "0.5rem 1rem", border_radius: "6px", border: "1px solid #b9bec8", background_color: "#334155", color: "#b9bec8", font_size: "1rem", width: "100%")
    css.rule(".btn-container", display: "flex", flex_direction: "column", gap: "2rem",justify_content: "center", margin: "2rem 0")
    css.rule("button", padding: "0.8rem 2.4rem", cursor: "pointer", border_radius: "4px", border: "none", font_size: "inherit", text_decoration: "none", text_align: "center")
    css.rule("button[type='submit']", color: "#1e293b", background_color: "#f0f0f0", border: "1px solid #f1f5f9", transition: "all 0.3s ease")
    css.rule("button[type='reset']", color: "#b9bec8", background_color: "#334155", border: "2px solid #1e1e2e")
    css.rule("button[type='submit']:hover", background_color: "#c5ced7")
    css.rule("button[type='reset']:hover", background_color: "#4d4d5c")
    css.media("min-width: 1024px") do |mq|
      mq.rule("fieldset", grid_template_columns: "1fr 1fr")
      mq.rule(".full-width", grid_column: "span 2")
      mq.rule(".btn-container", flex_direction: "row")
    end

    footer_css(css)
  end
end