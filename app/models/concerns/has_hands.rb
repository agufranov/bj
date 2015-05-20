module HasHands
  extend ActiveSupport::Concern

  included do
    embeds_many :hands, :as => :has_hands

    def notify_standing
      game.notify_player_finished if(player? and hands.all? { |hand| hand.standing? })
    end

    def player?
      raise NotImplementedError
    end

    def double_bet
      update :bet => bet * 2
    end

    private
      def init_hands
        self.hands.build
      end
  end
end
