class Hand
  include Mongoid::Document
  include AASM

  field :state

  embeds_many :cards, :as => :has_cards

  embedded_in :has_hands, :polymorphic => true

  aasm :column => :state do
    state :playing, :initial => true
    state :stand
  end

  def hit
    cards << has_hands.game.take_card.dup
  end

  def can_hit?
    true
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
