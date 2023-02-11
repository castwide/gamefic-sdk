RSpec.describe 'Examples (Web)', type: :feature, js: true do
  before :all do
    @tmp = Dir.mktmpdir
    Gamefic::Sdk::Scaffold.build 'project', @tmp
    Gamefic::Sdk::Scaffold.build 'react', @tmp
    Dir.chdir @tmp do
      `cd #{@tmp} && npm install`
    end
    Capybara.app = Rack::Files.new(@tmp)
  end

  after :all do
    FileUtils.remove_entry @tmp
  end

  Dir[File.join('examples', '*')].each do |dir|
    next unless File.directory?(dir)

    it "runs #{dir} test in web app to conclusion" do
      FileUtils.copy "#{dir}/main.rb", "#{Capybara.app.root}/main.rb", preserve: false
      Dir.chdir Capybara.app.root do
        `cd #{Capybara.app.root} && npm run build`
      end

      page.visit '/builds/web/production/index.html'
      wait_for_class(page, 'CommandForm')
      form = page.find('.CommandForm')
      field = form.find_field(type: 'text')
      field.fill_in with: 'test me'
      field.native.send_keys :enter
      wait_for_class(page, 'ConclusionScene')
    end
  end

  def wait_for_class(page, class_name, timeout = 10)
    start = Time.now
    while page.evaluate_script("document.getElementsByClassName('#{class_name}').length == 0")
      sleep(0.1)
      raise "Timeout waiting #{timeout}s for #{class_name}" if Time.now - start > timeout
    end
  end
end
