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
	
		if move[:captured]
			move[:captured].destroy
		end

	 	update_firebase(
	 		move: move, 
	 		x_position: params[:x_position] ,
	 		y_position: params[:y_position] , 
	 		id: params[:id],
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
		base_uri = 'https://dazzling-fire-5900.firebaseio.com/'

		firebase = Firebase::Client.new(base_uri)

		response = firebase.push('update_piece', data)
		response.success?
	end

end
