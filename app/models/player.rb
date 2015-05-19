class Player
  include Mongoid::Document
  include AASM

  field :aasm_state
  field :balance, :type => Integer, :default => ->{ Rails.application.config.player_defaults[:balance] }
  field :bet, :type => Integer, :default => ->{ Rails.application.config.player_defaults[:bet] }

  validates_numericality_of :bet, :only_integer => true, :less_than_or_equal_to => :balance, :greater_than => 0

  embedded_in :game

  aasm do
    state :betting, :initial => true
    state :playing

    event :to_play do
      transitions :from => :betting, :to => :playing
    end

    event :to_bet do
      transitions :from => :playing, :to => :betting, :guard => :do_bet
    end
  end

  private
    def do_bet(bet)
      self.update :bet => bet
    end
end
