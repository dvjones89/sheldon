require "byebug"
require 'coveralls'
require "rspec"
require "simplecov"

# # This must remain as the first import, before any application code is required.
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter "/spec/"
end

# This must remain below the SimpleCov declarations, else code coverage calculations are inaccurate
require_relative "../lib/sheldon"


