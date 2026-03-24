module RandomPeople
  class PeopleService
    def initialize(client:, mapper:)
      @client = client
      @mapper = mapper
    end

    def execute
      raw_response = @client.fetch(count: 2)
      users_array = raw_response.fetch("results", [])
      users_array.map do |user|
        @mapper.map_data(user)
      end
    end
  end
end