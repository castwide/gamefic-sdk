RSpec.describe 'Examples (Ruby)' do
  # after :each do
  #   Gamefic::Plot.blocks.pop
  # end

  before :all do
    @tmpdir = Dir.mktmpdir
    Gamefic::Sdk::Scaffold.build 'project', @tmpdir
  end

  after :all do
    FileUtils.remove_entry @tmpdir
  end

  Dir[File.join('examples', '*')].each do |dir|
    next unless File.directory?(dir)

    it "runs #{dir} test to conclusion" do
      Dir.mktmpdir do |tmpdir|
        name = File.basename(dir)
        Gamefic::Sdk::Scaffold.build 'project', File.join(tmpdir, name)
        FileUtils.cp File.join(dir, 'plot.rb'), File.join(tmpdir, name, 'lib', name, 'plot.rb')
        load File.join(tmpdir, name, 'main.rb')
        plot = GAMEFIC_PLOT_CLASS.new
        narrator = Gamefic::Narrator.new(plot)
        char = plot.introduce
        char.perform 'test me'
        until char.queue.empty?
          narrator.finish
          narrator.start
        end
        expect(char).to be_concluding
      end
    end
  end
end
