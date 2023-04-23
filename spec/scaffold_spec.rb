require 'tmpdir'

RSpec.describe Gamefic::Sdk::Scaffold do
  it 'does not overwrite files' do
    Dir.mktmpdir do |dir|
      expect {
        Gamefic::Sdk::Scaffold.build('project', dir)
      }.not_to raise_error
      expect {
        Gamefic::Sdk::Scaffold.build('project', dir)
      }.to raise_error(RuntimeError)
    end
  end

  it 'sets filenames' do
    Dir.mktmpdir do |dir|
      base = File.basename(dir)
      gemspec = File.join(dir, "#{base}.gemspec")
      Gamefic::Sdk::Scaffold.build('library', dir)
      expect(File.exist?(gemspec)).to be(true)
    end
  end
end
