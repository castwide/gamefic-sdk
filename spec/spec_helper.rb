# frozen_literal_string: true

require 'bundler/setup'
require 'simplecov'
require 'capybara/rspec'
require 'fileutils'
require 'selenium-webdriver'
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

if ENV['CAPYBARA_REMOTE_DRIVER']
  Capybara.register_driver :selenium_remote_firefox do |app|
    options = Selenium::WebDriver::Firefox::Options.new
    Capybara::Selenium::Driver.new(app, browser: :remote, url: 'http://127.0.0.1:4444', options: options)
  end
  Capybara.javascript_driver = :selenium_remote_firefox
end
