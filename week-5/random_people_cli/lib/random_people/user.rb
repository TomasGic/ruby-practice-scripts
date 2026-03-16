class User

  attr_reader :full_name, :age, :country, :group
 
  def initialize(first_name:, last_name:, age:, country:)
    @first_name = String(first_name).strip.capitalize
    @last_name = String(last_name).strip.capitalize
    @age = Integer(age)
    @country = String(country).strip.capitalize
    @group = self.adult? ? "adult" : "minor"
    validate!
  end

  def full_name
    "#{@first_name} #{@last_name}"
  end
  
  def adult?
    @age >= 18
  end

  private
 
  def validate!
    raise "first_name required" if @first_name.empty?
    raise "last_name required" if @last_name.empty?
    raise "country required" if @country.empty?
    raise "age must be >= 0" if @age < 0
  end
end







