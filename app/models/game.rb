class Game
  include Mongoid::Document
  include AASM

  embeds_one :player
  embeds_one :dealer
  embeds_many :shoes, :class_name => 'Card', :as => :has_cards
  embeds_many :beaten, :class_name => 'Card', :as => :has_cards
  field :beaten, :type => Array, :default => []
  field :state, :type => String

  before_create :init

  aasm :column => :state do
    state :new, :initial => true
    state :started
    state :round_finished
    state :insufficient_funds
    state :out_of_cards

    event :finish do
      transitions :from => :started, :to => :round_finished
    end

    event :new_round do
      transitions :from => [:round_finished, :new], :to => :started
    end

    event :to_insufficient_funds do
      transitions :from => :started, :to => :insufficient_funds
    end

    event :to_out_of_cards do
      transitions :from => :started, :to => :out_of_cards
    end
  end

  def take_card
    shoes.pop
  end

  # Начальная раздача карт
  def first_deal
    player.hands = [player.hands[0]]

    [dealer, player].each do |p|
      p.hand.reset! unless p.hand.playing?
      2.times { p.hand.hit! }
    end

    save!
    new_round! unless started?
  end

  def init
    shoes << Card.deck # инициализируем шуз одной колодой
    build_dealer
    dealer.init_hands
    build_player
    player.init_hands
  end

  def notify_player_finished
    dh, ph = dealer.hand, player.hand
    if player.hands.all? &:busted?
      dealer.hand.stand! unless dealer.hand.standing?
    end

    while dh.playing? and shoes.any? do
      dh.hit!
    end

    player.inc :balance => player.bet * (player <=> dealer)

    if player.balance == 0
      to_insufficient_funds!
    elsif shoes.count < 4
      to_out_of_cards!
    else
      finish!
      player.to_bet! unless player.betting?
    end
  end
end
