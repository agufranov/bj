class Card
  include Mongoid::Document
  include Mongoid::Enum
  
  enum :suit, [:spades]#, :hearts, :diamonds, :clubs]
  # enum :value, (2..10).map { |x| "c#{x}".to_sym } + [:k, :j, :q, :a]
  enum :value, [:k, :q, :j, :a]

  embedded_in :has_cards, :polymorphic => true

  def mongoize
    { :suit => self.suit, :value => self.value }
  end

  def self.deck
    Card::SUIT.product(Card::VALUE).shuffle.map { |t| { :suit => t[0], :value => t[1] } } # заполняем шуз одной колодой
  end

  class << self
    def demongoize(o)
      Card.new o
    end

    def mongoize(o)
      case o
      when Card then o.mongoize
      else o
      end
    end

    def evolve(o)
      case o
      when Card then o.mongoize
      else o
      end
    end

    def display_suit(card)
      { :hearts => '♠', :spades => '♥', :diamonds => '♦', :clubs => '♣' }[card[:suit]]
    end

    def display(card)
      "[#{card[:value]} #{Card.display_suit(card)}]"
    end

    def get_value(card)
      case card[:value]
      when :a2 then 2
      when :a3 then 3
      when :a4 then 4
      when :a5 then 5
      when :a6 then 6
      when :a7 then 7
      when :a8 then 8
      when :a9 then 9
      when :a10, :j, :q, :k then 10
      when :a then { :min => 1, :max => 11 }
      end
    end
  end
end
