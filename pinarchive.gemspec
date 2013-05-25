# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pinarchive/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mispy"]
  gem.email         = ["^_^@mispy.me"]
  gem.description   = %q{Command-line tool for downloading Pinterest boards}
  gem.summary       = %q{Command-line tool for downloading Pinterest boards}
  gem.homepage      = "https://github.com/mispy/pinarchive"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pinarchive"
  gem.require_paths = ["lib"]
  gem.version       = Pinarchive::VERSION
end
