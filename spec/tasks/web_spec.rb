require 'gamefic-sdk/tasks'
require 'tmpdir'

RSpec.describe Gamefic::Sdk::Tasks::Web do
  it "generates web apps" do
    Dir.mktmpdir do |dir|
      Gamefic::Sdk::Scaffold.build('project', dir)
      tasks = Gamefic::Sdk::Tasks::Web.new(dir)
      tasks.generate
      expect(File.exist?(File.join(dir, 'web', 'package.json'))).to be(true)
    end
  end

  it "raises errors when building nonexistent web apps" do
    Dir.mktmpdir do |dir|
      tasks = Gamefic::Sdk::Tasks::Web.new(dir)
      expect {
        tasks.build
      }.to raise_error(LoadError)
    end
  end

  it "raises errors when running nonexistent web apps" do
    Dir.mktmpdir do |dir|
      tasks = Gamefic::Sdk::Tasks::Web.new(dir)
      expect {
        tasks.run
      }.to raise_error(LoadError)
    end
  end

  it "builds web apps" do
    Dir.mktmpdir do |dir|
      Dir.chdir dir do
        Gamefic::Sdk::Scaffold.build('project', dir)
        tasks = Gamefic::Sdk::Tasks::Web.new(dir)
        tasks.generate
        tasks.build
        expect(File.exist?(File.join(dir, 'web', 'build', 'index.html'))).to be(true)
        expect(File.exist?(File.join(dir, 'web', 'build', 'bundle.js'))).to be(true)
      end
    end
  end
end
