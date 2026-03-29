module RandomPeople
  class UnsupportedFormatError < StandardError; end
  class ApiError < StandardError; end
end

require "random_people/user"
require "random_people/user_mapper"
require "random_people/clients/random_user_client"
require "random_people/http/net_http_adapter"
require "random_people/http/response"
require "random_people/formatters/table_formatter"
require "random_people/formatters/json_formatter"
require "random_people/people_service"
require "random_people/cli"