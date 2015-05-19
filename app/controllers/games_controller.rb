class GamesController < ApplicationController
  before_action :set_game, :only => [:show, :bet, :end_move_stub]

  def new
    @game = Game.new
  end

  def create
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
    rescue AASM::InvalidTransition
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

  private
    def set_game
      @game = Game.find params[:id]
      @game.player.reload
    end

    def bet_params
      params.permit(:bet)
    end
end
