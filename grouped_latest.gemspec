$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "grouped_latest/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "grouped_latest"
  s.version     = GroupedLatest::VERSION
  s.authors     = ["tnantoka"]
  s.email       = ["tnantoka@bornneet.com"]
  s.homepage    = "https://github.com/tnantoka/grouped_latest"
  s.summary     = "Get the latest record from each group on ActiveRecord."
  s.description = "Just another scope to fetch the latest record with specified group."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "mysql2"
end
