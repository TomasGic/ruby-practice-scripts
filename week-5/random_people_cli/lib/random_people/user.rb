module RandomPeople
  class User
    attr_reader :first_name, :last_name, :full_name, :age, :group, :country
    def initialize(first_name:, last_name:, age:, country:)
      @first_name = normalize(first_name)
      @last_name = normalize(last_name)
      @age = Integer(age)
      @group = self.adult? ? "adult" : "minor"
      @country = normalize(country)

      validate!
    end

    def full_name
      "#{@first_name} #{@last_name}"
    end

    def adult?
      @age >= 18
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