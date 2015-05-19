class Game
  include Mongoid::Document

  embeds_one :player

  after_initialize :after_initialize

  private
    def after_initialize
      self.build_player
    end
end
