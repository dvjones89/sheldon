$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  require 'sheldon/sheldon'

  s.name        = 'Sheldon'
  s.version     = ::Sheldon::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Another config and dotfile manager for unix environments"
  s.description = "Teach Sheldon about your most important files and he'll recall them on your different machines. Heck, he'll even build bespoke configs for you, if you like."
  s.authors     = ["David Jones"]
  s.email       = 'david@dvj.me.uk'
  s.homepage    = 'https://github.com/dvjones89/sheldon'
  s.license       = 'MIT'

  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'
  s.executables   = 'sheldon'

  s.add_runtime_dependency 'thor', '~> 0.9'
  s.add_development_dependency "rake", '~> 11.1'
  s.add_development_dependency 'rspec', '~> 3.3'
  s.add_development_dependency 'simplecov', '~> 0.10'
end
