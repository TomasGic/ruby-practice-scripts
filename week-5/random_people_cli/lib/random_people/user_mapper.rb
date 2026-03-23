module RandomPeople
  class UserMapper
    def self.map_data(raw)
      User.new(
        first_name: raw.dig("name", "first"),
        last_name: raw.dig("name", "last"),
        age: raw.dig("dob", "age"),
        country: raw.dig("location", "country"),
        email: raw["email"]
      )
    end
  end
end