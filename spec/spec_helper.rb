Dir["#{File.dirname(__FILE__)}/../lib/*/*.rb"].each { |f| require f }
require_relative '../lib/sheldon'

require "byebug"

RSpec.configure do |config|
  config.mock_with :mocha
end
