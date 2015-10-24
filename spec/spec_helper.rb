Dir["#{File.dirname(__FILE__)}/../lib/*/*.rb"].each { |f| require f }
require_relative '../lib/sheldon'

require 'memfs'

RSpec.configure do |c|
  c.around(:each, memfs: true) do |example|
    MemFs.activate { example.run }
  end
end
