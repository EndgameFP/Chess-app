class PiecesController < ApplicationController
	
	respond_to :json
	def update
		@current = Piece.find_by_id(params[:id])
		@game = Game.find_by_id(@current.game_id)
		@pieces = @game.pieces
		
		@pieces.each do |piece|
			piece.update_attribute(:is_selected, false)
		end

		@current.update_attribute(:x_position, params[:x_position])
		@current.update_attribute(:y_position, params[:y_position])
		respond_with @current 
	end


	private
	def pieces_params 
		params.require(:piece).permit(:piece_id, :user_id, :x_position, :y_position)
	end
end
