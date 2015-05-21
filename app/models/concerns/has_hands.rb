# Модуль содержит общие методы для игрока и дилера
module HasHands
  extend ActiveSupport::Concern
  include Comparable

  included do
    embeds_many :hands, :as => :has_hands

    def hand
      hands.first
    end

    # Callback для оповещения о том, что одна из "рук" завершила ход
    def notify_standing
      game.notify_player_finished if(player? and hands.all? { |hand| hand.standing? })
    end

    # true для игрока, false для дилера
    def player?
      raise NotImplementedError
    end

    def can_double?
      bet * 2 <= balance and hands.count == 1
    end

    def can_split?
      can_double? and hand.cards.count == 2
    end

    def double_bet
      update!(:bet => bet * 2) if can_double?
    end

    # Сравнение по очкам
    def <=>(other)
      nil unless other.class.ancestors.include? HasHands
      essential_score <=> other.essential_score
    end

    # Численное значение очков
    # (исходя из того, что может быть несколько "рук")
    def essential_score
      hands.map(&:sum).select { |s| s <= 21 }.max or 0
    end

    private
      def init_hands
        self.hands.build
      end
  end
end
