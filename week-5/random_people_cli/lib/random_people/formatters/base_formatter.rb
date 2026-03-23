require "net/http"
require "json"

url = URI("https://randomuser.me/api/?results=3")
res = Net::HTTP.get(url)
data = JSON.parse(res)

data["results"].each do |user|
  puts user.dig("name", "first")
  puts user.dig("dob", "age")
  puts user.dig("location", "country")
  puts "------------------------------"
end

