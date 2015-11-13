require "simplecov"
require "pry-byebug"

# This must remain as the first import, before any application code is required.
SimpleCov.start do
  add_filter "/spec/"
end

require_relative "../lib/sheldon"
