module RandomPeople
  class PeopleService
    def initialize(client:, mapper:)
      @client = client
      @mapper = mapper
    end

    def execute(count:)
      raw_response = @client.fetch(count: count)
      users_array = raw_response.fetch("results", [])
      users_array.map do |user|
        @mapper.map_data(user)
      end
    end
  end
end