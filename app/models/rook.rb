class Rook < Piece
	def is_valid?(dest_x, dest_y)
		dx = dest_x - self.x_position
		dy = dest_y - self.y_position

		return true if dx == 0 || dy == 0
		return false
	end
end