class GamesController < ApplicationController
	before_action :authenticate_user!

	def index
		@games = Game.all
	end
	
	def new
		@game = Game.new
	end

	def create
		@game = Game.new(games_params)
		# @game.white_player_id = current_user.id
		if @game.save 
		 redirect_to @game
		else
		 render 'new'
		end
	end

	def show
		@game = Game.find_by_id(params[:id])
	end

	def destroy
		@game = Game.find_by_id(params[:id])
		@game.destroy
		redirect_to root_path
	end

	private

	def games_params
		params.require(:game).permit(:name, :status, :white_player_id, 
			:black_player_id, :turn_player_id)
	end


end
