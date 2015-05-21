require 'rails_helper'

RSpec.describe Game, :type => :model do
  # let(:game) { FactoryGirl.create :game }
  game = FactoryGirl.create :game

  context 'when new' do
    it 'should have new state' do
      expect(game.state).to eq 'new'
    end

    it 'should have player initialized' do
      expect(game.player).to be_truthy
    end

    it 'should have dealer initialized' do
      expect(game.dealer).to be_truthy
    end

  end
end
