class Hand
  include Mongoid::Document

  field :cards, :type => Array, :default => []

  embedded_in :has_hands, :polymorphic => true

  def sum
    cards.reduce(0) do |sum, card|
      val = Card.get_value card
      if val.is_a? Hash
        if sum + val[:max] < 21
          val = val[:max]
        else
          val = val[:min]
        end
      end
      sum + val
    end
  end
end
