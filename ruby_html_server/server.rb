require 'webrick'
require_relative 'lib/router'
require_relative 'lib/pages/home_page'
require_relative 'lib/pages/about_page'
require_relative 'lib/pages/contact_page'

router = Router.new
home_page = HomePage.new
about_page = AboutPage.new
contact_page = ContactPage.new

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
server = WEBrick::HTTPServer.new(Port: 3000)

server.mount_proc '/' do |req, res|
  status, content_type, body = router.resolve(method: req.request_method, path: req.path)
  res.status = status
  res['Content-Type'] = "#{content_type}; charset=utf-8"
  res.body = body
end

trap('INT') { server.shutdown }

puts "Server running at <http://localhost:3000>"
server.start