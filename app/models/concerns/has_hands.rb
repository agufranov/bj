module HasHands
  extend ActiveSupport::Concern

  included do
    embeds_many :hands, :as => :has_hands

    # before_create :init_hands

    # field :hands, :type => Array, :default => [[]]
    #
    # def reset_hands
    #   self.update :hands => [[]]
    # end
    #
    # def take_card
    #   self.hands.first.push self.game.take_card
    # end
    
    private
      def init_hands
        puts 'INIT HANDS'
        self.hands.build
      end
  end
end
