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
      expect(page).to have_css('input[type=text]')
      field = page.find('input[type=text]')
      field.fill_in with: 'test me'
      field.native.send_keys :enter
      expect(page).to have_css('div[data-scene-type=Conclusion]', visible: false)
    end
  end
end
