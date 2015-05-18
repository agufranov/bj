class Player
  include Mongoid::Document
  include AASM

  field :aasm_state
  field :balance, :type => Integer
  field :bet, :type => Integer

  validates_numericality_of :bet, :only_integer => true, :greater_than => 0

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
      puts 'BET!'
      puts bet
      true
    end
end
