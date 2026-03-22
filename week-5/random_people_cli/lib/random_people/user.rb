module RandomPeople
  class User
    attr_reader :first_name, :last_name, :full_name, :age, :group, :country
    def initialize(first_name:, last_name:, age:, country:)
      @first_name = first_name
      @last_name = last_name
      @age = age
      @group = self.adult? ? "adult" : "minor"
      @country = country
    end

    def full_name
      "#{@first_name} #{@last_name}"
    end

    def adult?
      @age >= 18
    end
  end
end