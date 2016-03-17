class PiecesController < ApplicationController
	def update
		@current = Piece.find_by_id(params[:id])
		@game = Game.find_by_id(@current.game_id)
		@pieces = @game.pieces
		@selected = @pieces.map(&:is_selected)
		@selected_piece = @pieces.find_by_is_selected(true)
		
		if @selected.include?(true) && @current.id == @selected_piece.id
			@current.update_attribute(:tile_id, params[:tile_id])
		end
		@pieces.each do |piece|
			@z = piece.tile_id.split('-')
			piece.update_attribute(:x_position, @z[0].to_i)
			piece.update_attribute(:y_position, @z[1].to_i)

			piece.update_attribute(:is_selected, false)
		end

		@current.update_attribute(:is_selected, true)
		
		redirect_to game_path(@game)

	end

	private
	def pieces_params 
		params.require(:piece).permit(:is_selected, :game_id, :piece_id, :user_id, :x_position, :y_position)
	end
end
