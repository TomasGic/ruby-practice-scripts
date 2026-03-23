module RandomPeople
  class User
    attr_reader :first_name, :last_name, :full_name, :age, :group, :country, :email
    def initialize(first_name:, last_name:, age:, country:, email:)
      @first_name = normalize(first_name)
      @last_name = normalize(last_name)
      @age = Integer(age)
      @group = self.adult? ? "adult" : "minor"
      @country = normalize(country)
      @email = email.nil? ? nil : String(email).strip.downcase
      validate!
    end

    def full_name
      "#{@first_name} #{@last_name}"
    end

    def adult?
      @age >= 18
    end

    def to_h
      {
        full_name: self.full_name,
        email: @email,
        country: @country,
        age: @age,
        group: @group
      }
    end

    private
    def normalize(string)
      String(string).strip.gsub(/\b\w/) { |char| char.upcase }
    end

    def validate!
      raise "first_name required" if first_name.empty?
      raise "last_name required" if last_name.empty?
      raise "country required" if country.empty?
      raise "age must be >= 0" if age < 0
    end
  end
end