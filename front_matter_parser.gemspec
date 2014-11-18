# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'front_matter_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "front_matter_parser"
  spec.version       = FrontMatterParser::VERSION
  spec.authors       = ["marc"]
  spec.email         = ["marc@lamarciana.com"]
  spec.description   = %q{Library to parse files or strings with YAML front matters with syntax autodetection.}
  spec.summary       = %q{FrontMatterParser is a library to parse files or strings with YAML front matters. When working with files, it can automatically detect the syntax of a file from its extension and it supposes that the front matter is marked as that syntax comments.}
  spec.homepage      = "https://github.com/waiting-for-dev/front_matter_parser"
  spec.license       = "LGPL3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5", "<1.6"
  spec.add_development_dependency "rake", "~>10.1"
  spec.add_development_dependency "rspec", "~> 2.14"
end
