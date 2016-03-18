class PiecesController < ApplicationController
	
	respond_to :json
	def update
		@current = Piece.find_by_id(params[:id])
		@game = @current.game
		@pieces = @game.pieces
		
		logger.debug "HII"
		@pieces.each do |piece|
			logger.debug piece.x_position==params[:x_position]
			logger.debug piece.y_position==params[:y_position]
			if piece.x_position.to_i==params[:x_position].to_i&&piece.y_position.to_i==params[:y_position].to_i
			    logger.info("GO OVER")
				return respond_to do |format|
					format.json { render :json => {:message => "Fail",:status => :not_found } }
				end
				
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
