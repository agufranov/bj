module HasHands
  extend ActiveSupport::Concern
  include Comparable

  included do
    embeds_many :hands, :as => :has_hands

    def hand
      hands.first
    end

    def notify_standing
      game.notify_player_finished if(player? and hands.all? { |hand| hand.standing? })
    end

    def player?
      raise NotImplementedError
    end

    def can_double?
      bet * 2 <= balance and hands.count == 1
    end

    def can_split?
      can_double?
    end

    def double_bet
      update!(:bet => bet * 2) if can_double?
    end

    def <=>(other)
      nil unless other.class.ancestors.include? HasHands
      essential_score <=> other.essential_score
    end

    def essential_score
      hands.map(&:sum).select { |s| s <= 21 }.max or 0
    end

    private
      def init_hands
        self.hands.build
      end
  end
end
