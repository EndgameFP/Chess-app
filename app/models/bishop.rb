class Bishop < Piece
	def is_valid?(dest_x, dest_y)
		dx = dest_x - self.x_position
 		dy = dest_y - self.y_position
		
		return true if dx.abs == dy.abs
		return false
	end
end
