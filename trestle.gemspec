# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trestle/version'

Gem::Specification.new do |spec|
  spec.name          = "trestle"
  spec.version       = Trestle::VERSION
  spec.authors       = ["Sam Pohlenz"]
  spec.email         = ["sam@sampohlenz.com"]

  spec.summary       = "Trestle Admin Framework"
  spec.homepage      = "https://www.trestleadmin.io"
  spec.license       = "LGPL-3.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails",              "~> 5.0.0"
  spec.add_dependency "sass-rails",         "~> 5.0.6"
  spec.add_dependency "coffee-rails",       "~> 4.2.1"
  spec.add_dependency "autoprefixer-rails", "~> 6.4.0"
  spec.add_dependency "kaminari",           "~> 0.17.0"

  spec.add_development_dependency "bundler",     "~> 1.12"
  spec.add_development_dependency "rake",        "~> 10.0"
  spec.add_development_dependency "rspec-rails", "~> 3.5"
  spec.add_development_dependency "rspec-html-matchers", "~> 0.7.1"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "turbolinks"
end
