# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pipe/version'

Gem::Specification.new do |spec|
  spec.name          = "pipe-ruby"
  spec.version       = Pipe::VERSION
  spec.authors       = ["Dan Matthews, Paul Hanyzewski"]
  spec.email         = ["devs@teamsnap.com"]
  spec.summary       = %q{Ruby implementation of the UNIX pipe}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/teamsnap/pipe-ruby"
  spec.license       = "MIT"

  spec.files         = Dir.glob("**/*.rb")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.3"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
end
