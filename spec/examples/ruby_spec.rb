RSpec.describe 'Examples (Ruby)' do
  Dir[File.join('examples', '*')].each do |dir|
    next unless File.directory?(dir)

    it "runs #{dir} test to conclusion" do
      load File.join(dir, 'main.rb')
      plot = Gamefic::Plot.new
      char = plot.get_player_character
      plot.introduce char
      char.perform 'test me'
      until char.queue.empty?
        plot.ready
        plot.update
      end
      expect(char).to be_concluded
      Gamefic::Plot.blocks.pop
    end
  end
end
