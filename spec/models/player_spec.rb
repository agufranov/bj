require 'rails_helper'

RSpec.describe Player, :type => :model do
  let(:game) { Game.create }

  it 'should create with game' do
    expect(game.player).to be_truthy
  end

  it 'should have 100 as default bet' do
    expect(game.player.bet).to equal 100
  end
end
