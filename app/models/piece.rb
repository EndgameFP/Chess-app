class Piece < ActiveRecord::Base
	belongs_to :game
	belongs_to :user

	


	def make_move(x,y)
		
	end



 	def is_obstructed?(x,y)
 		# Needs to see if any pieces are positioned between piece's current location and destination 
 		game = self.game
		pieces = game.pieces
		pieces.each do |piece|
			if piece.x_position.to_i==x&&piece.y_position.to_i==y
				#return true
			end
		end
		return false
    end


	def is_valid?(x,y)
		# Template for each model's definition
	end
end
