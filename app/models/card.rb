class Card
  include Mongoid::Document
  include Mongoid::Enum
  
  enum :suit, [:spades]#, :hearts, :diamonds, :clubs]
  # enum :value, (2..10).map { |x| "c#{x}".to_sym } + [:k, :j, :q, :a]
  enum :value, [:k, :q, :j, :a]

  embedded_in :has_cards, :polymorphic => true

  def display_suit
    { :hearts => '♠', :spades => '♥', :diamonds => '♦', :clubs => '♣' }[suit]
  end

  def display
    "[#{value} #{display_suit}]"
  end

  def get_value
    case value
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

  def self.deck
    Card::SUIT.product(Card::VALUE).shuffle.map { |t| Card.new :suit => t[0], :value => t[1] } # заполняем шуз одной колодой
  end
end
