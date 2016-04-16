class PiecesController < ApplicationController
	
	respond_to :json
	
	def update
		@current = Piece.find_by_id(params[:id])
		orig_x = @current.x_position
		orig_y = @current.y_position
		move=@current.make_move(params[:x_position].to_i,params[:y_position].to_i)
		if move[:valid]
			@current.update_attribute(:has_moved, true)
		end
	
		if move[:captured]
			move[:captured].destroy
		end

		if move[:en_passant]
			move[:en_passant].destroy
		end


		if move[:checkmate]
			@current.game.set_status("Complete")
		end

	 	update_firebase(
	 		piece: @current,	 		
	 		move: move, 
	 		your_turn: @current.game.turn_player_id,
	 		orig_x: orig_x,
	 		orig_y: orig_y , 
	 		time_stamp: Time.now)
	 	

		respond_to do |format|
			format.json { render :json => move }
		end

	end
	
	private
	def pieces_params 
		params.require(:piece).permit(:id, :user_id, :x_position, :y_position)
	end

	def update_firebase(data)
		base_uri = 'https://boiling-heat-305.firebaseio.com/'

		firebase = Firebase::Client.new(base_uri)

		response = firebase.set('update_piece', data)
		response.success?
	end

end
