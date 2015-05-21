require 'rails_helper'

shared_examples_for HasHands do |model|
  it { should be_truthy }
  its(:hands) { is_expected.to have_exactly(1).items }
  context 'hand' do
    its('hand.state') { should eq 'playing' }
  end

  describe :hands do
  end
end

RSpec.describe Game, :type => :model do
  # game = FactoryGirl.create :game

  context 'new' do
    let(:game) { FactoryGirl.create :game }
    subject { game }

    its(:state) { should eq 'new' }

    its(:shoes) { is_expected.to have_exactly(52).items }

    context 'player' do
      subject { game.player }

      it_behaves_like HasHands
      its(:state) { should eq 'betting' }
    end

    context 'dealer' do
      subject { game.dealer }

      it_behaves_like HasHands
    end
  end

  context 'started' do
    before :each do
      @game = FactoryGirl.create :game
      @game.player.to_play! 100
    end

    subject { @game }

    its(:state) { is_expected.to eq 'started' }

    context 'player' do
      subject { @game.player }

      its(:state) { is_expected.to eq 'playing' }
    end

  end
end
