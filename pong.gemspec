
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pong/version"

Gem::Specification.new do |spec|
  spec.name          = "pong"
  spec.version       = Pong::VERSION
  spec.authors       = ["liamiam"]
  spec.email         = ["liam@liamiam.com"]

  spec.summary       = %q{pong in ruby.}
  spec.homepage      = "https://github.com/LiamCoal/pong"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = ["pong"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "ruby2d"
end
