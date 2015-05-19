require 'rails_helper'

RSpec.describe Player, :type => :model do
  let(:game) { Game.create }

  it 'should create with game' do
    expect(game.player).to be_truthy
  end

  it 'should have default balance as in config' do
    expect(game.player.balance).to equal Rails.application.config.player_defaults[:balance]
  end

  it 'should have default bet as in config' do
    expect(game.player.bet).to equal Rails.application.config.player_defaults[:bet]
  end
end
