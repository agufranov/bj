require 'rails_helper'

RSpec.describe Player, :type => :model do
  let(:player) { Game.create.player }

  it 'should create with game' do
    expect(player).to be_truthy
  end

  it 'should have default balance as in config' do
    expect(player.balance).to equal Rails.application.config.player_defaults[:balance]
  end

  it 'should have default bet as in config' do
    expect(player.bet).to equal Rails.application.config.player_defaults[:bet]
  end

  it 'cannot have balance <= 0' do
    update_result = player.update :balance => -1
    expect(update_result).to be false
  end

  it 'cannot have bet <= 0' do
    update_result = player.update :bet => -1
    expect(update_result).to be false
  end

  it 'cannot have bet greater than balance' do
    update_result = player.update :balance => 100, :bet => 1000
    expect(update_result).to be false
  end

  # TODO transitions
end
