class Hand
  include Mongoid::Document
  include AASM

  field :state, :type => String

  embeds_many :cards, :as => :has_cards

  embedded_in :has_hands, :polymorphic => true

  aasm :column => :state do
    state :playing, :initial => true
    state :standing

    event :stand, :after => :notify_standing do
      transitions :from => :playing, :to => :standing
    end

    event :reset do
      transitions :from => :standing, :to => :playing, :guard => :reset_guard
    end
  end

  def hit!
    cards << has_hands.game.take_card.dup if playing?
    check
  end

  def double!
    if has_hands.player?
      has_hands.double_bet
      hit!
      stand! unless standing?
    end
  end

  def split!
    if can_split?
      other_hand = has_hands.hands.create
      other_hand.cards << cards.pop.dup
    end
  end

  def can_split?
    has_hands.hands.count == 1
  end

  def busted?
    sum > 21
  end

  def blackjack?
    sum == 21
  end

  def reset_guard
    self.cards = []
  end

  def notify_standing
    has_hands.notify_standing
  end

  def check
    if has_hands.game.shoes.any?
      if has_hands.player?
        stand! if busted? or blackjack?
      else
        stand! if sum > 17
      end
    else
      has_hands.hands.each do |hand|
        hand.stand! unless hand.standing?
      end
    end
  end

  def sum
    cards.reduce(0) do |sum, card|
      val = card.get_value
      if val.is_a? Hash
        if sum + val[:max] <= 21
          val = val[:max]
        else
          val = val[:min]
        end
      end
      sum + val
    end
  end
end
