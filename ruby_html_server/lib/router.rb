require_relative "html_builder"
require_relative "style_builder"
require_relative "page_builder" 
require_relative "pages/not_found_page"

class Router
  attr_reader :routes
  
  def initialize
    @routes = {}
  end

  def add_route(method:, path:, &handler)
    @routes["#{method} #{path}"] = handler
  end

  def resolve(method:, path:, params: {})
    handler = @routes["#{method} #{path}"]
    if handler
      result = handler.call(params)
      if result.is_a?(Array)
        css_string = result[1]
        [200, "text/css", css_string]
      else
        [200, "text/html", result]
      end
    else
      [404, "text/html", not_found_page(path)]
    end
  end

  private

  def not_found_page(path)
    NotFoundPage.new(path: path).render
  end
end 
