class Game
  include Mongoid::Document

  embeds_one :player
  embeds_one :dealer
  field :shoes, :type => Array, :default => ->{ Card.deck } # инициализируем шуз одной колодой
  field :beaten, :type => Array, :default => []

  before_create :init

  def take_card
    self.shoes.pop
  end

  # Начальная раздача карт
  def first_deal
    [self.dealer, self.player].each { |p| 2.times { p.hands.first.cards << take_card } }
    self.save!
  end

  def init
    self.build_dealer
    self.dealer.init_hands
    self.build_player
    self.player.init_hands
  end
end
