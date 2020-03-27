require 'fileutils'
require 'tmpdir'

RSpec.describe 'Examples (Web)', :type => :feature, :js => true do
  before :all do
    @tmp = Dir.mktmpdir
    Gamefic::Sdk::Scaffold.build 'project', @tmp
    Gamefic::Sdk::Scaffold.build 'react', @tmp
  end

  after :all do
    FileUtils.remove_entry @tmp
  end

  Dir[File.join('examples', '*')].each do |dir|
    next unless File.directory?(dir)

    it "runs #{dir} test in web app to conclusion" do
      FileUtils.copy "#{dir}/main.rb", "#{@tmp}/main.rb", preserve: false
      Dir.chdir @tmp do
        `cd #{@tmp} && npm install && npm run build`
      end
      Capybara.app.root = @tmp
      expect { Capybara.app.run_test page }.not_to raise_error
    end
  end
end
