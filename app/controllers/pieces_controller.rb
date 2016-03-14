class PiecesController < ApplicationController
	def update
		@current = Piece.find_by_id(params[:id])
		@game = Game.find_by_id(@current.game_id)
		@pieces = @game.pieces
		
		@pieces.each do |piece|
			piece.update_attribute(:is_selected, false)
		end
		
		@current.update_attribute(:is_selected, true)
		redirect_to game_path(@game)

	end

	private
	def pieces_params 
		params.require(:piece).permit(:is_selected, :game_id, :piece_id)
	end
end
