require_relative "html_builder"
require_relative "style_builder"
require_relative "page_builder"

class Router
  def initialize
    @routes = {}
  end

  def add_route(method:, path:, &handler)
    @routes["#{method} #{path}"] = handler
  end

  def resolve(method:, path:)
    handler = @routes["#{method} #{path}"]
    if handler
      [200, "text/html", handler.call]
    else
      [404, "text/html", not_found_page(path)]
    end
  end

  private

  def not_found_page(path)
    page = PageBuilder.new(title: "404 - Page Not Found")

    page.build do
      h1_heading = HtmlBuilder.content_tag(:h1, content: "404 - Not Found")
      paragraph = HtmlBuilder.content_tag(
      :p, 
      content: "Sorry, the content you've requested at #{path} does not exist or has been moved."
      )

      "#{h1_heading}\n#{paragraph}"
    
    end
  end
end