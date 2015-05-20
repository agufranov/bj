class Card
  include Mongoid::Document
  include Mongoid::Enum
  
  enum :suit, [:spades, :hearts, :diamonds, :clubs]
  enum :value, (2..10).map { |x| "c#{x}".to_sym } + [:k, :j, :q, :a]
  # enum :value, [:k, :q, :j, :a]

  embedded_in :has_cards, :polymorphic => true

  def display_suit
    { :hearts => '♠', :spades => '♥', :diamonds => '♦', :clubs => '♣' }[suit]
  end

  def display_value
    if(m = value.to_s.match /c(\d+)/)
      m[1]
    else value.to_s.upcase!
    end
  end

  def display
    "[#{display_value} #{display_suit}]"
  end

  def get_value
    if(m = value.to_s.match /c(\d+)/)
      m[1].to_i
    elsif [:j, :q, :k].include? value
      puts 2
      10
    elsif value == :a
      puts 3
      { :min => 1, :max => 11 }
    end
  end

  def self.deck
    Card::SUIT.product(Card::VALUE).shuffle.map { |t| Card.new :suit => t[0], :value => t[1] } # заполняем шуз одной колодой
  end
end