RSpec.describe 'Examples (Web)', type: :feature, js: true do
  before :all do
    @tmpdir = Dir.mktmpdir
    Capybara.app = Rack::Files.new(@tmpdir)
  end

  after :all do
    FileUtils.remove_entry @tmpdir
  end

  Dir[File.join('examples', '*')].each do |dir|
    next unless File.directory?(dir)

    it "runs #{dir} test in web app to conclusion" do
      name = File.basename(dir)
      Gamefic::Sdk::Scaffold.build 'project', File.join(@tmpdir, name)
      Dir.chdir File.join(@tmpdir, name) do
        Gamefic::Sdk::Tasks::Web.new.generate
      end
      FileUtils.cp File.join(dir, 'plot.rb'), File.join(@tmpdir, name, 'lib', name, 'plot.rb')
      Dir.chdir File.join(@tmpdir, name, 'web') do
        `npm run build`
      end

      page.visit "/#{name}/web/build/index.html"
      expect(page).to have_css('input[type=text]')
      field = page.find('input[type=text]')
      field.fill_in with: 'test me'
      field.native.send_keys :enter
      expect(page).to have_css('div[data-scene-type=Conclusion]', visible: false)
    end
  end
end
