lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gamefic-sdk/version'
require 'date'

Gem::Specification.new do |s|
  s.name          = 'gamefic-sdk'
  s.version       = Gamefic::Sdk::VERSION
  s.date          = Date.today.strftime("%Y-%m-%d")
  s.summary       = "Gamefic SDK"
  s.description   = "Development and command-line tools for Gamefic"
  s.authors       = ["Fred Snyder"]
  s.email         = 'fsnyder@gamefic.com'
  s.homepage      = 'http://gamefic.com'
  s.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|examples|guides)/}) }
  end
  s.executables   = ['gamefic']
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.6.0'

  s.add_runtime_dependency 'gamefic', '~> 2.4'
  s.add_runtime_dependency 'gamefic-standard', '~> 2.4'
  s.add_runtime_dependency 'gamefic-tty', '~> 2.0', '>= 2.0.2'
  s.add_runtime_dependency 'listen', '~> 3.0'
  s.add_runtime_dependency 'opal', '~> 1.1'
  s.add_runtime_dependency 'sinatra', '~> 2'
  s.add_runtime_dependency 'thor', '~> 1.0'

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'capybara', '~> 3.3'
  s.add_development_dependency 'puma', '~> 6'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'selenium-webdriver', '~> 4.1'
  s.add_development_dependency 'simplecov', '~> 0.14'
end
