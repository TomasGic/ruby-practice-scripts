lib = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'random_people'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
end