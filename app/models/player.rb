class Player
  include Mongoid::Document
  include AASM
  include HasHands

  field :state, :type => String
  field :balance, :type => Integer, :default => ->{ Rails.application.config.player_defaults[:balance] }
  field :bet, :type => Integer, :default => ->{ Rails.application.config.player_defaults[:bet] }

  validates_numericality_of :balance, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :bet, :only_integer => true, :less_than_or_equal_to => :balance, :greater_than => 0

  embedded_in :game

  aasm :column => :state do
    state :betting, :initial => true # делает ставку
    state :playing # играет

    event :to_play do
      transitions :from => :betting, :to => :playing, :guard => :set_bet
    end

    event :to_bet do
      transitions :from => :playing, :to => :betting
    end
  end

  def player?
    true
  end

  private
    def set_bet(bet)
      update! :bet => bet
      game.first_deal
    end
end
