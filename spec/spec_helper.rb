require "bundler/setup"
require 'simplecov'
require 'capybara/rspec'
require 'fileutils'
require 'tmpdir'

SimpleCov.start

require "gamefic-sdk"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    @tmp = Dir.mktmpdir
    Gamefic::Sdk::Scaffold.build 'project', @tmp
    Gamefic::Sdk::Scaffold.build 'react', @tmp
    Dir.chdir @tmp do
      `cd #{@tmp} && npm install`
    end
    Capybara.app = Rack::Files.new(@tmp)
    if ENV['CAPYBARA_REMOTE_DRIVER']
      puts "Registering remote Selenium driver"
      Capybara.register_driver :selenium_remote_firefox do |app|
        Capybara::Selenium::Driver.new(app, browser: :remote, url: "http://localhost:4444/wd/hub", desired_capabilities: :firefox)
      end
      Capybara.javascript_driver = :selenium_remote_firefox
    end
  end

  config.after(:all) do
    FileUtils.remove_entry @tmp
  end
end

# @todo This is a horrendous hack to keep `Net::OpenTimeout` from raising an error.
#   See https://groups.google.com/g/ruby-capybara/c/XteY3i5pg1A
module CapybaraServerHack
  def responsive?
    super
  rescue Net::OpenTimeout
    false
  end
end

class Capybara::Server
  prepend CapybaraServerHack
end
