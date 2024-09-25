# frozen_string_literal: true

RSpec.describe 'gameplay' do
  let(:plot) { GAMEFIC_PLOT_CLASS.new }

  let(:commands) do
    # Customize this array of commands to reach a conclusion
    [
      'look around'
    ]
  end

  it 'reaches a conclusion' do
    player = plot.introduce
    player.queue.concat commands
    plot.ready
    until player.queue.empty?
      plot.update
      plot.ready
    end
    expect(plot).to be_concluding
  end
end
