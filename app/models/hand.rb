# Одна "рука" игрока/дилера.
# Содержит методы для действий пользователя,
# проверки очков и состояний выигрыша/проигрыша.
class Hand
  include Mongoid::Document
  include AASM

  #TODO patternify

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

  # Взять карту
  def hit!
    cards << has_hands.game.take_card.dup if playing?
    check
  end

  # Взять карту, удвоить ставку и завершить ход
  def double!
    if has_hands.player? and has_hands.can_double?
      has_hands.double_bet
      hit!
      stand! unless standing?
    end
  end

  # Разбить на две руки
  # Для удобства тестирования сплит возможен и при неодинаковых картах!
  def split!
    if has_hands.can_double?
      has_hands.double_bet
      other_hand = has_hands.hands.create
      other_hand.cards << cards.pop.dup
      # TODO only if equal
    end
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

  # Проверка.
  # "Рука" переходит в состояние standing,
  # если блэкджек/проигрыш/закончились карты.
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

  # Алгоритм подсчета очков, учитывая тузы.
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
