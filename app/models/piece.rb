class Piece < ActiveRecord::Base
	belongs_to :game
	belongs_to :user

 	def is_obstructed?(x,y)
 		game = self.game
		pieces = game.pieces
		pieces.each do |piece|
			if piece.x_position.to_i==x&&piece.y_position.to_i==y
				return false
			end
		end
		return true
    end


	def valid_move?(x,y)
		return self.is_obstructed?(x,y)
	end
end
