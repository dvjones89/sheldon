require "byebug"
require 'coveralls'
require "rspec"
require "simplecov"
require_relative "../lib/sheldon"

# # This must remain as the first import, before any application code is required.
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter "/spec/"
end

