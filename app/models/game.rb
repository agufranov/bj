class Game
  include Mongoid::Document

  embeds_one :player

  before_create :b

  private
    def b
      self.build_player
    end
end
