class Game
  include Mongoid::Document

  embeds_one :player
  embeds_one :dealer
  embeds_many :shoes, :class_name => 'Card', :as => :has_cards
  embeds_many :beaten, :class_name => 'Card', :as => :has_cards
  field :beaten, :type => Array, :default => []

  before_create :init

  def take_card
    self.shoes.pop
  end

  # Начальная раздача карт
  def first_deal
    [self.dealer, self.player].each { |p| 2.times { p.hands.first.hit } }
    self.save!
  end

  def init
    self.shoes << Card.deck # инициализируем шуз одной колодой
    self.build_dealer
    self.dealer.init_hands
    self.build_player
    self.player.init_hands
  end
end
