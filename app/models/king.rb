class King < Piece
	def is_valid?(dest_x, dest_y)
 		dx = dest_x - self.x_position
  		dy = dest_y - self.y_position
 		
 		return true if dx.abs == 1 && dy.abs == 0 || dx.abs == 0 && dy.abs == 1 || dx.abs == 1 && dy.abs == 1
 		
 		return true if castling? && dy.abs == 2 && dx == 0
 		return false
  	end
  	
  	## no pieces between king and rook, and both are at their original positions
	def castling?
		rooks = self.game.pieces.where("user_id = ? AND type = ?", self.user_id, "Rook")
		rooks.each do |rook|
			if !rook.has_moved && !self.has_moved && !rook.pieces_between?(self.x_position, self.y_position)
				return true 
			end
		end
		return false
	end

end
