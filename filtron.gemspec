Gem::Specification.new do |spec|
  spec.name          = "filtron"
  spec.version       = "0.0.1"
  spec.authors       = ["Lee Jarvis"]
  spec.email         = ["ljjarvis@gmail.com"]
  spec.description   = "Pretty aliases for filtering your data"
  spec.summary       = "Simple filtering"
  spec.homepage      = "https://github.com/leejarvis/filtron"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(/^test/)
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
