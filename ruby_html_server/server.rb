require 'webrick'
require_relative 'lib/router'
require_relative 'lib/pages/home_page'

router = Router.new
home_page = HomePage.new

router.add_route(method: "GET", path: "/") { home_page.render }
router.add_route(method: "GET", path: "/styles/home.css") do
  ["text/css", home_page.build_styles]
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