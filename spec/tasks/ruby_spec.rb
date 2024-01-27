require 'gamefic-sdk/tasks'
require 'tmpdir'

RSpec.describe Gamefic::Sdk::Tasks::Ruby do
  it 'builds Ruby apps' do
    Dir.mktmpdir do |dir|
      Gamefic::Sdk::Scaffold.build 'project', dir
      built = File.join(dir, 'ruby', 'build', "#{File.basename(dir)}.rb")
      tasks = Gamefic::Sdk::Tasks::Ruby.new(dir)
      tasks.build
      expect(File.exist?(built)).to be(true)
    end
  end
end
