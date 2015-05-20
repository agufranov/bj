module HasHands
  extend ActiveSupport::Concern

  included do
    embeds_many :hands, :as => :has_hands

    private
      def init_hands
        self.hands.build
      end
  end
end
