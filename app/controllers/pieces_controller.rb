class PiecesController < ApplicationController
	
	respond_to :json

	def is_valid?(piece,current_user,new_x,new_y)
		@game = @current.game
		@pieces = @game.pieces
		@pieces.each do |piece|
			if piece.x_position.to_i==new_x&&piece.y_position.to_i==new_y
				return false
			end
		end
		return true
	end

	def update
		@current = Piece.find_by_id(params[:id])
		@current_user = User.find_by_id(params[:user_id])
		
		
		if !is_valid?(@current,@current_user,params[:x_position].to_i,params[:y_position].to_i)
			return respond_to do |format|
				format.json { render :json => {:message => "Fail",:status => :not_found } }
			end
		end

		@current.update_attribute(:x_position, params[:x_position])
		@current.update_attribute(:y_position, params[:y_position])
		respond_to do |format|
			format.json { render :json => {:message => "success"} }
		end
	end


	private
	def pieces_params 
		params.require(:piece).permit(:id, :user_id, :x_position, :y_position)
	end
end
