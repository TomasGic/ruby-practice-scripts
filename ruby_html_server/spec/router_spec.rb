RSpec.describe Router do
  let(:router) { Router.new }

  describe "#initialize" do
    it "starts with an empty routes hash" do
      expect(router.routes).to eq({})
    end
  end

  describe "#add_route" do
    it "stores a route handler using a combined method and path string key" do
      router.add_route(method: "GET", path: "/test") { "Test Page Content" }
      
      expect(router.routes).to have_key("GET /test")
      expect(router.routes["GET /test"]).to be_a(Proc)
      expect(router.routes["GET /test"].call).to eq("Test Page Content")
    end
  end

  describe "#resolve" do
    context "when the route matches an HTML page handler" do
      before do
        router.add_route(method: "GET", path: "/home") { "<h1>Welcome Home</h1>" }
      end

      it "returns a 200 status, text/html content type, and the raw string body" do
        status, content_type, body = router.resolve(method: "GET", path: "/home")
        
        expect(status).to eq(200)
        expect(content_type).to eq("text/html")
        expect(body).to eq("<h1>Welcome Home</h1>")
      end
    end

    context "when the route matches a CSS stylesheet handler" do
      before do
        # Emulate your server.rb returning an array like: ["text/css", "body { ... }"]
        router.add_route(method: "GET", path: "/styles/home.css") do
          ["text/css", "body { background: color; }"]
        end
      end

      it "detects the Array return, extracting the CSS string and serving text/css" do
        status, content_type, body = router.resolve(method: "GET", path: "/styles/home.css")
        
        expect(status).to eq(200)
        expect(content_type).to eq("text/css")
        expect(body).to eq("body { background: color; }")
      end
    end

    context "when the route does not exist (404 status code)" do
      let(:fake_404_html) { "<html><body><h1>404 - Not Found</h1></body></html>" }

      before do
        # We stub NotFoundPage so the test doesn't depend on your real HTML layout logic
        mock_page = instance_double(NotFoundPage)
        allow(NotFoundPage).to receive(:new).with(path: "/unknown-path").and_return(mock_page)
        allow(mock_page).to receive(:render).and_return(fake_404_html)
      end

      it "returns a 404 status code, text/html content type, and invokes the NotFoundPage" do
        status, content_type, body = router.resolve(method: "GET", path: "/unknown-path")
        
        expect(status).to eq(404)
        expect(content_type).to eq("text/html")
        expect(body).to eq(fake_404_html)
      end
    end
  end
end