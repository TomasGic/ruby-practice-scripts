module RandomPeople
  class User
    attr_reader :first_name, :last_name, :age, :group, :country, :email
    def initialize(first_name:, last_name:, age:, country:, email:)
      @first_name = normalize(first_name, "N/A")
      @last_name = normalize(last_name, "N/A")
      @age = parse_age(age)
      @group = get_group
      @country = normalize(country, "N/A")
      @email = email.nil? ? "N/A" : String(email).strip.downcase
      
    end

    def adult?
      @age >= 18
    end

    def full_name
      "#{@first_name} #{@last_name}"
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
    def normalize(string, default_value)
      value = String(string).strip
      value.empty? || value.nil? ? default_value : value.gsub(/\b\w/) { |char| char.upcase }
    end

    def parse_age(age)
      return "Invalid" if age.nil? || age.to_s.strip.empty?
      value = age.to_i
      value > 0 ? value : "Invalid"
    end

    def get_group
      return "N/A" if @age == "Invalid"
      @age >=18 ? "adult" : "minor"
    end
  end
end
