class Queen < Piece
	def is_valid?(dest_x, dest_y)
		dx = (self.x_position - dest_x).abs #calculates the change in x
		dy = (self.y_position - dest_y).abs #calculates the change in y

		return true if dx == 0 || dy == 0 || dy == dx #if moving horizontally, vertically, or diagonally
		return false
	end
end