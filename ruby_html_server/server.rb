require 'webrick'
require_relative 'lib/router'
require_relative 'lib/pages/home_page'
require_relative 'lib/pages/about_page'
require_relative 'lib/pages/contact_page'

router = Router.new
home_page = HomePage.new
about_page = AboutPage.new
contact_page = ContactPage.new
not_found_page = NotFoundPage.new

router.add_route(method: "GET", path: "/") { home_page.render }
router.add_route(method: "GET", path: "/styles/home.css") do
  ["text/css", home_page.build_styles]
end

router.add_route(method: "GET", path: "/about") { about_page.render }
router.add_route(method: "GET", path: "/styles/about.css") do
  ["text/css", about_page.build_styles]
end

router.add_route(method: "GET", path: "/contact") { contact_page.render }
router.add_route(method: "GET", path: "/styles/contact.css") do
  ["text/css", contact_page.build_styles]
end

router.add_route(method: "GET", path: "/styles/notfound.css") do
  ["text/css", not_found_page.build_styles]
end

router.add_route(method: "POST", path: "/submit") do |params|
  parsed_params = params.transform_values { |value| HtmlBuilder.escape(value) } 
  contact_page.render_success(parsed_params)
end

server = WEBrick::HTTPServer.new(Port: 3000)

server.mount_proc '/' do |req, res|
  if req.request_method == "POST"
    p req.query
  end
  status, content_type, body = router.resolve(method: req.request_method, path: req.path, params: req.query)
  res.status = status
  res['Content-Type'] = "#{content_type}; charset=utf-8"
  res.body = body
end

trap('INT') { server.shutdown }

puts "Server running at <http://localhost:3000>"
server.start