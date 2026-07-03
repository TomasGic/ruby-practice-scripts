RSpec.describe HtmlBuilder do
  describe ".tag" do
    it "generates a void tag" do
      expect(HtmlBuilder.tag(:br)).to eq("<br>")
    end

    it "generates a void tag with attributes when they are provided" do
      expect(HtmlBuilder.tag(:a, class: "home-btn", href: "/")).to eq("<a class='home-btn' href='/'>")
    end

    it "renders boolean attribute as name-only when true" do
      result = HtmlBuilder.tag(:input, type: "text", required: true)
      expect(result).to include("required")
      expect(result).not_to include('required="true"')
    end

    it "omits boolean attribute when false" do
      result = HtmlBuilder.tag(:input, type: "text", required: false)
      expect(result).not_to include("required")
    end
  end

  describe ".content_tag" do
    it "wraps content in a tag" do
      expect(HtmlBuilder.content_tag(:p, content: "Hello")).to eq("<p>Hello</p>")
    end
    it "accepts a block for content" do
      result = HtmlBuilder.content_tag(:div, class: "container") { "inner html" }
      expect(result).to eq("<div class='container'>inner html</div>")
    end
  end

  describe ".escape" do
    it "escapes HTML special characters" do
      expect(HtmlBuilder.escape('<script>alert("xss")</script>'))
        .to eq("&lt;script&gt;alert(&quot;xss&quot;)&lt;/script&gt;")
    end
  end

  describe ".list" do
    it "generates an unordered list" do
      result = HtmlBuilder.list(["A", "B"], type: :ul)
      expect(result).to include("<ul>", "<li>A</li>", "<li>B</li>", "</ul>")
    end

    it "generates an ordered list with attributes" do
      result = HtmlBuilder.list(["First", "Second"], type: :ol, class: "steps")
      expect(result).to include("<ol class='steps'>")
    end
  end

  describe ".table" do
    it "generates a table with caption, headers, and rows" do
      result = HtmlBuilder.table(
        headers: ["Name", "Age"],
        rows: [["Alice", 30]],
        caption: "People"
      )
      expect(result).to include("<caption>People</caption>")
      expect(result).to include("<th scope='col'>Name</th>")
      expect(result).to include("<td>Alice</td>")
      expect(result).to include("<td>30</td>")
    end
  end

  describe ".labeled_input" do
    it "generates a label + input pair" do
      result = HtmlBuilder.labeled_input(label: "Email", name: "email", type: "email", required: true)
      expect(result).to include("<label for='email'>Email</label>")
      expect(result).to include("type='email'")
      expect(result).to include("id='email'")
      expect(result).to include("required")
    end
  end

  describe ".labeled_select_input" do
    it "generates a label-select pair" do
      select_values = ["mentoring", "collaboration", "feedback", "question", "other"]
      result = HtmlBuilder.labeled_select_input(values: select_values, label: "Subject", id: "subject", name: "subject", required: true)
      expect(result).to include("<label for='subject'>Subject</label>")
      expect(result).to include("<select name='subject' id='subject' required>")
      expect(result).to include("<option value='mentoring'>Mentoring</option>")
    end
  end

  describe ".nav" do
    it "generates a nav element with links" do
      links = [{ text: "Home", href: "/" }, { text: "About", href: "/about" }]
      result = HtmlBuilder.nav(links, aria_label: "Main navigation")
      expect(result).to include("<nav aria-label='Main navigation'>")
      expect(result).to include("<a href='/'>Home</a>")
      expect(result).to include("<a href='/about'>About</a>")
    end
  end

  describe ".html_document" do
    it "generates a complete HTML5 document" do
      result = HtmlBuilder.html_document(title: "Test") { "<p>Body</p>" }
      expect(result).to include("<!DOCTYPE html>")
      expect(result).to include("<html lang='en'>")
      expect(result).to include("<meta charset='UTF-8'>")
      expect(result).to include("<title>Test</title>")
      expect(result).to include("<p>Body</p>")
    end
  end
end