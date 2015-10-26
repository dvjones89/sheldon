# This must remain as the first import, before any application code is required.
require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

Dir["#{File.dirname(__FILE__)}/../lib/*/*.rb"].each { |f| require f }
require_relative "../lib/sheldon"

require "byebug"

include Helpers
