$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  require 'sheldon/sheldon'
  require 'date'

  s.name        = 'sheldon'
  s.version     = ::Sheldon::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Another config and dotfile manager for unix environments"
  s.description = s.summary
  s.authors     = ["David Jones"]
  s.email       = 'david@dvj.me.uk'
  s.homepage    = 'https://github.com/dvjones89/sheldon'
  s.license       = 'MIT'

  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'
  s.executables   = 'sheldon'

  s.add_runtime_dependency 'thor'
  s.add_runtime_dependency 'tty-prompt'
  s.add_development_dependency "rake"
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'coveralls'
end
