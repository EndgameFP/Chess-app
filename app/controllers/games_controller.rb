class GamesController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :show, :destroy, :update]

	def index
		@games = Game.all
	end
	
	def new
		@game = Game.new
	end


	def create
		@game = Game.create(games_params)
		if @game.valid? 
			@game.update_attribute(:white_player_id, current_user.id)
			redirect_to @game
		else
			render 'new', status: :unprocessable_entity
		end
	end

	def show
		@game = Game.find_by_id(params[:id])
		@current_user=current_user
		@user = User.all
		@pieces = @game.pieces
		@selected_piece = @pieces.find_by_is_selected(true)
		## whether a pieces is selected
		@pieces_on_tiles = @pieces.map(&:tile_id)

	end

	def update
		@game = Game.find_by_id(params[:id])
		if @game.white_player_id != current_user.id
			@game.update_attribute(:black_player_id, current_user.id)
			@game.set_up_game
			redirect_to @game
		else
			redirect_to root_path, alert: 'Cannot play yourself' 
		end
	end

	def destroy
		@game = Game.find_by_id(params[:id])
		@game.destroy
		redirect_to root_path
	end

	private

	def games_params
		params.require(:game).permit(:name, :status, :white_player_id, 
			:black_player_id, :turn_player_id, :game_id)
	end

end
