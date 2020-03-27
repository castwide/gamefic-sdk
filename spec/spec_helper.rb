require "bundler/setup"
require 'simplecov'
require 'capybara/rspec'

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

class TestFileServer < Rack::File
  attr_writer :root

  def initialize
    super(nil, {}, 'text/html')
  end

  def run_test page
    page.visit '/builds/web/production/index.html'
    wait_for_class(page, 'CommandForm')
    form = page.find('.CommandForm')
    field = form.find_field(type: 'text')
    field.fill_in with: 'test me'
    field.native.send_keys :enter
    wait_for_class(page, 'ConclusionScene')
  end

  private

  def wait_for_class(page, class_name, timeout = 10)
    start = Time.now
    while page.evaluate_script("document.getElementsByClassName('#{class_name}').length == 0")
      sleep(0.1)
      raise "TestFileServer timed out waiting for #{class_name}" if Time.now - start > timeout
    end
  end
end

Capybara.app = TestFileServer.new
