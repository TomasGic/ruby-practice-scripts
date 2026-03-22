module RandomPeople
  class User
    attr_reader :first_name, :last_name, :full_name, :age, :group
    def initialize(first_name:, last_name:, age:)
      @first_name = first_name
      @last_name = last_name
      @age = age
      @group = self.adult? ? "adult" : "minor"
    end

    def full_name
      "#{@first_name} #{@last_name}"
    end

    def adult?
      @age >= 18
    end
  end
end