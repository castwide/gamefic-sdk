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

  it 'adds react to projects' do
    Dir.mktmpdir do |dir|
      expect {
        Gamefic::Sdk::Scaffold.build('project', dir)
        Gamefic::Sdk::Scaffold.build('react', dir)
      }.not_to raise_error
    end
  end
end
