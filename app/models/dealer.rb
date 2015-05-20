class Dealer
  include Mongoid::Document
  include HasHands

  embedded_in :game

  def player?
    false
  end
end
