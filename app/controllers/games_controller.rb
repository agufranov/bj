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
      options = { :notice => 'Ставка сделана' }
    rescue Mongoid::Errors::Validations
      options = { :alert => 'Неверная ставка' }
    end

    redirect_to @game, options
  end

  def hand_action
    hand = @game.player.hands.find hand_params[:hand_id]
    hand.public_send hand_params[:type]
    options = {}
    if @game.round_finished?
      case @game.player <=> @game.dealer
      when 1 then options[:notice] = 'Победа'
      when -1 then options[:alert] = 'Поражение'
      when 0 then options[:notice] = 'Ничья'
      end
    elsif @game.insufficient_funds?
      options[:alert] = 'Закончились деньги'
    elsif @game.out_of_cards?
      options[:alert] = 'Нет больше карт'
    end
      
    redirect_to @game, options
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
