require "net/http"
require "json"

url = URI("https://randomuser.me/api/?results=3")
res = Net::HTTP.get(url)
data = JSON.parse(res)

users = data["results"]

users_filtered = users.map do |user|
  { "first_name" => user.dig("name", "first") }
end

p users_filtered.sort_by { |u| u["first_name"] }


