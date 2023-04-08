RSpec.describe 'Examples (Ruby)' do
  Dir[File.join('examples', '*')].each do |dir|
    next unless File.directory?(dir)

    it "runs #{dir} test to conclusion" do
      load File.join(dir, 'main.rb')
      plot = Gamefic::Plot.new
      char = plot.make_player_character
      plot.introduce char
      plot.ready
      char.perform 'test me'
      until char.queue.empty?
        plot.update
        plot.ready
      end
      Gamefic::Plot.blocks.pop
      expect(char).to be_concluding
    end
  end
end
