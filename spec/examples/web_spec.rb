RSpec.describe 'Examples (Web)', type: :feature, js: true do
  before :all do
    @tmp = Dir.mktmpdir
    Gamefic::Sdk::Scaffold.build 'project', @tmp
    Dir.chdir @tmp do
      Gamefic::Sdk::Tasks::Web.new.generate
    end
    Capybara.app = Rack::Files.new(File.join(@tmp))
  end

  after :all do
    FileUtils.remove_entry @tmp
  end

  Dir[File.join('examples', '*')].each do |dir|
    next unless File.directory?(dir)

    it "runs #{dir} test in web app to conclusion" do
      FileUtils.copy "#{dir}/main.rb", "#{Capybara.app.root}/main.rb", preserve: false
      Dir.chdir File.join(Capybara.app.root, 'web') do
        `npm run build`
      end

      page.visit '/web/build/index.html'
      expect(page).to have_selector('input[type=text]')
      field = page.find('input[type=text]')
      field.fill_in with: 'test me'
      field.native.send_keys :enter
      # @todo Figure out a way to verify the game concluded
    end
  end
end
