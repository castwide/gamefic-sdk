lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gamefic-sdk/version'
require 'date'

Gem::Specification.new do |spec|
  spec.name          = 'gamefic-sdk'
  spec.version       = Gamefic::Sdk::VERSION
  spec.date          = Date.today.strftime('%Y-%m-%d')
  spec.summary       = 'Gamefic SDK'
  spec.description   = 'Development and command-line tools for Gamefic'
  spec.authors       = ['Fred Snyder']
  spec.email         = 'fsnyder@gamefic.com'
  spec.homepage      = 'https://gamefic.com'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = 'https://gamefic.com'
  spec.metadata['source_code_uri'] = 'https://github.com/castwide/gamefic-sdk'
  spec.metadata['changelog_uri'] = 'https://github.com/castwide/gamefic-sdk/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|examples|guides)/}) }
  end
  spec.executables   = ['gamefic']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7.0'

  spec.add_runtime_dependency 'gamefic', '~> 4.1'
  spec.add_runtime_dependency 'gamefic-standard', '~> 4.0'
  spec.add_runtime_dependency 'gamefic-tty', '~> 4.0'
  spec.add_runtime_dependency 'listen', '~> 3.0'
  spec.add_runtime_dependency 'opal', '~> 1.1'
  spec.add_runtime_dependency 'opal-rspec', '~> 1.0'
  spec.add_runtime_dependency 'opal-sprockets', '~> 1.0'
  spec.add_runtime_dependency 'puma', '~> 6'
  spec.add_runtime_dependency 'rake', '~> 13.0'
  spec.add_runtime_dependency 'rspec', '~> 3.0'
  spec.add_runtime_dependency 'sinatra', '~> 2'
  spec.add_runtime_dependency 'thor', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'capybara', '~> 3.3'
  spec.add_development_dependency 'selenium-webdriver', '~> 4.2'
  spec.add_development_dependency 'simplecov', '~> 0.14'
end
