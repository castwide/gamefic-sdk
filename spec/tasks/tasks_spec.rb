RSpec.describe Gamefic::Sdk::Tasks do
  it 'defines tasks' do
    expect {
      Gamefic::Sdk::Tasks.define_all
    }.not_to raise_error
  end
end
