# -*- encoding: utf-8 -*-
require File.expand_path('../lib/securities/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nedomas"]
  gem.email         = ["domas.bitvinskas@me.com"]
  gem.description   = %q{Financial information scraper gem. Uses Yahoo Finance API.}
  gem.summary       = %q{Financial information scraper gem. Uses Yahoo Finance API.}
  gem.homepage      = "https://github.com/Nedomas/securities"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "securities"
  gem.require_paths = ["lib"]
  gem.version       = Securities::VERSION

  gem.add_dependency 'rails'
  gem.add_development_dependency 'rspec'
end
