class GamesController < ApplicationController
  before_action :set_game, :only => [:show, :bet, :end_move_stub, :hand_action]

  def new
    @game = Game.new
  end

  def create
    Game.destroy_all # debug
    @game = Game.new

    if @game.save
      redirect_to @game
    else
      render :new
    end
  end

  def bet
    begin
      @game.player.to_play! bet_params[:bet]
      notice = 'Ставка сделана'
    rescue Mongoid::Errors::Validations
      notice = 'Ставка не сделана'
    end

    redirect_to @game, :notice => notice
  end

  def end_move_stub
    begin
      @game.player.to_bet!
      notice = 'Ход сделан'
    rescue AASM::InvalidTransition
      notice = 'Ход не сделан'
    end

    redirect_to @game, :notice => notice
  end

  def hand_action
    hand = @game.player.hands.find hand_params[:hand_id]
    hand.public_send hand_params[:type]
    redirect_to @game
  end

  def stand
  end

  private
    def set_game
      @game = Game.find params[:id]
    end

    def set_hand
    end

    def bet_params
      params.permit(:bet)
    end

    def hand_params
      params.permit(:type, :hand_id)
    end
end
