class PiecesController < ApplicationController
	
	respond_to :json
	
	def update
		@current = Piece.find_by_id(params[:id])
		move=@current.make_move(params[:x_position].to_i,params[:y_position].to_i)
		if move[:valid]
			#@current.update_attribute(:x_position, params[:x_position])
			#@current.update_attribute(:y_position, params[:y_position])
			@current.update_attribute(:has_moved, true)
		end
	
		respond_to do |format|
			format.json { render :json => move }
		end

		if move[:captured]
			move[:captured].destroy
		end

		if move[:checkmate]
			flash.keep[:alert] = "Checkmate!"
			@current.game.set_status("Complete")
		end

	end
	
	private
	def pieces_params 
		params.require(:piece).permit(:id, :user_id, :x_position, :y_position)
	end

end
