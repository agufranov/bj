FactoryGirl.define do
  factory :game do
  end

  factory :game_dealer_wins, :class => Game do
    after :create do |game|
      game.shoes = [:a, :c10, :c2, :c2, :c2, :c2, :c2, :c2].map { |t| Card.new :suit => Card::SUIT.sample, :value => t }.reverse
    end
  end

  factory :game_player_wins, :class => Game do
    after :create do |game|
      game.shoes = [:c10, :c10, :a, :c8, :c2, :c2, :c2, :c2, :c2, :c2, :c2, :c2].map { |t| FactoryGirl.build :card, :value => t }.reverse
    end
  end

  factory :game_out_of_cards, :class => Game do
    after :create do |game|
      game.shoes = FactoryGirl.build_list :card, 5, :value => :c2
    end
  end

  factory :game_no_first_blackjack, :class => Game do
    after :create do |game|
      game.shoes = FactoryGirl.build_list :card, 52, :value => :c2
    end
  end
end
