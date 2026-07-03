module HtmlBuilder
  def self.tag(name, **attributes) #we pass the tag as symbol not string - clarify why?
    attributes = map_attributes(attributes)
    "<#{name}#{attributes}>"
  end

  def self.content_tag(name, content: nil, **attributes, &block)
    content = block_given? ? yield : content.to_s
    opening_tag = tag(name, **attributes)
    closing_tag = "</#{name.to_s}>"
    "#{opening_tag}#{content}#{closing_tag}"
  end

  def self.html_document(title:, lang: "en", stylesheets: [], &block)
    content = block_given? ? yield : ""
    link_tags = stylesheets.map do |stylesheet|
      "<link rel='stylesheet' href='#{stylesheet}'>"
    end.join("\n")
    
    <<~HTML.strip
      <!DOCTYPE html>
      <html lang='#{lang}'>
      <head>
        <meta charset='UTF-8'>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>#{title}</title>
        #{link_tags}
      </head>
      <body>
        #{content}
      </body>
      </html>
    HTML
  end

  def self.list(items, type:, **attributes)
    opening_list_tag = tag(type, **attributes)
    closing_list_tag = "</#{type}>"
    list_items = items.map { |item| "<li>#{item}</li>" }.join("")
    
    "#{opening_list_tag}#{list_items}#{closing_list_tag}"
    
  end

  def self.definition_list(pairs, **attributes)
    attributes = map_attributes(attributes)
    pairs = pairs.map { |term, description| "<dt>#{term}</dt><dd>#{description}</dd>"}.join("")
    
    "<dl#{attributes}>#{pairs}</dl>"
  end

  def self.table(headers:, rows:, caption: nil, **attributes)
    attributes = map_attributes(attributes)
    caption_tag = caption ? "<caption>#{caption}</caption>" : ""
    headers = headers.map { |header| "<th>#{header.to_s}</th>" }.join("")
    rows = rows.map do |row| 
      row.map { |value| "<td>#{value}</td>" }.join("")
    end.map { |row| "<tr>#{row}</tr>"}.join("")
    
    "<table#{attributes}>#{caption_tag}<tr>#{headers}</tr>#{rows}</table>"
  end

  def self.nav(links, aria_label: nil, **attributes)
    links = links.map do |link|   
      "<a href='#{link[:href]}'>#{link[:text]}</a>"
    end.join("")
    attributes = map_attributes(attributes)
    if aria_label.nil? || aria_label.strip.empty? 
      "<nav#{attributes}>#{links}</nav>"
    else
      "<nav#{attributes} aria-label='#{aria_label}'>#{links}</nav>"
    end
  end

  def self.form(action:, method: "POST", **attributes, &block)
    form_attributes = attributes.merge(action: action, method: method)
    form_content = block_given? ? yield : ""
    form_html = content_tag(:form, content: form_content, **form_attributes)
    form_html
  end

  def self.labeled_input(label:, name:, type: "text", id: nil, **attributes)
    input_id = id || name
    label_html = content_tag(:label, content: label, for: input_id)
    input_attributes = attributes.merge(type: type, name: name, id: input_id)
    input_html = tag(:input, **input_attributes)
    "#{label_html}#{input_html}"
  end 

  def self.labeled_select_input(values:, label:, name:, id: nil, **attributes)
    input_id = id || name
    label_html = content_tag(:label, content: label, for: input_id)
  
    input_inner_html = [content_tag(:option, content: "Select a #{label}", value: "", selected: true, disabled: true)] + 
    values.map do |value|
      content_tag(:option, content: "#{value.capitalize}", value: value)
    end
    input_inner_html = input_inner_html.join("")
    
    input_html = content_tag(:select, name: name, id: input_id, required: true) do
      input_inner_html
    end

    "#{label_html}#{input_html}"
  end

  def self.labeled_textarea_input(label:, name:, id: nil, **attributes)
    input_id = id || name
    label_html = content_tag(:label, content: label, for: input_id)
    input_attributes = attributes.merge(name: name, id: input_id)
    input_html = content_tag(:textarea, **input_attributes)
    "#{label_html}#{input_html}"
  end

  def self.escape(text)
    return "" if text.nil? || text.strip.empty?
    text.to_s.gsub(/[&<>"']/) do |match|
      case match
      when "&" then "&amp;"
      when "<" then "&lt;"
      when ">" then "&gt;"
      when "'" then "&#39;"
      when '"' then "&quot;"
      end
    end
  end

  private 
  
  def self.map_attributes(attributes)
    attributes_string = attributes.map do |key, value| 
      if value == true
        key.to_s
      elsif value == false || value.nil?
        nil
      else
        "#{key}='#{value}'"
      end
    end.compact.join(" ")
    attributes_string = " #{attributes_string}" unless attributes_string.empty?
  end
    
end
