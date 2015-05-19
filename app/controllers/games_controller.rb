class GamesController < ApplicationController
  before_action :set_game, :only => [:show]

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

  private
    def set_game
      @game = Game.find params[:id]
    end
end
