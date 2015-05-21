require 'rails_helper'

shared_examples_for HasHands do
  it { should be_truthy }
  its(:hands) { is_expected.to have_exactly(1).items }
  context 'hand' do
    its('hand.state') { should eq 'playing' }
  end

  describe :hands do
  end
end

shared_examples_for :player_loses do |options|
  before :each do
    @game = FactoryGirl.create :game_dealer_wins
    @game.player.to_play options[:bet]
    @game.player.hand.stand!
  end

  subject { @game }

  its(:state) { should eq options[:final_state] }

  its('player.balance') { should eq options[:final_balance] }

end

RSpec.describe Game, :type => :model do
  context 'new' do
    let(:game) { FactoryGirl.create :game }
    subject { game }

    its(:state) { should eq 'new' }

    its(:shoes) { is_expected.to have_exactly(52).items }

    context 'player' do
      subject { game.player }

      it_behaves_like HasHands, 1
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

      it 'should take two cards' do
        expect(subject.hand.cards).to have_exactly(2).items
      end
    end

  end

  context 'dealer wins' do

    it_behaves_like :player_loses, :balance => 1000, :bet => 100, :final_balance => 900, :final_state => 'round_finished'

    it_behaves_like :player_loses, :balance => 1000, :bet => 1000, :final_balance => 0, :final_state => 'insufficient_funds'

  end

  context 'player wins' do
    before :each do
      @game = FactoryGirl.create :game_player_wins
      @initial_balance = @game.player.balance
      @bet = 100
      @game.player.to_play! @bet
      @game.player.hand.hit!
    end

    subject { @game }

    its(:state) { is_expected.to eq 'round_finished' }

    context 'player' do
      subject { @game.player }

      its(:balance) { is_expected.to eq @initial_balance + @bet }
    end
  end

  context 'out of cards after player hit' do
    before :each do
      @game = FactoryGirl.create :game_out_of_cards
      @game.player.to_play! 100
      @game.player.hand.hit!
    end

    subject { @game }

    its(:state) { is_expected.to eq 'out_of_cards' }
  end

  context 'possible moves' do
    before :each do
      @game = FactoryGirl.create :game_no_first_blackjack
      @initial_bet = 100
      @game.player.to_play! @initial_bet
    end

    subject { @game.player }

    it 'should can double' do
      expect(subject).to be_can_double
    end

    it 'should can split' do
      expect(subject).to be_can_split
    end

    context 'split' do
      before :each do
        @game.player.hand.split!
      end

      it 'should not can split after split' do
        expect(subject).not_to be_can_split
      end
      
      it 'should have doubled bet after split' do
        expect(subject.bet).to eq @initial_bet * 2
      end
    end
  end
end
