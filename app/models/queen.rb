class Queen < Piece
	def is_valid?(dest_x, dest_y)
		return false if is_obstructed?(dest_x, dest_y)
		#return false if causes_checkmate
		dx = (self.x_position - dest_x).abs #calculates the change in x
		dy = (self.y_position - dest_y).abs #calculates the change in y
		dx != 0 ? (slope = dy/dx) : (slope = 0) # finds slope if move isn't vertical/without slope

		if dx == 0 || dy == 0 || slope == 1 #if moving horizontally, vertically, or diagonally
			return true
		else
			return false
		end
	end
end