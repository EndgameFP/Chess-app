class Knight < Piece
	def is_valid?(dest_x, dest_y)

		abs_x = (dest_x - self.x_position).abs
		abs_y = (dest_y - self.y_position).abs

		if abs_x < 3 && abs_y < 3
			abs_x + abs_y == 3 ? (return true) : (return false)
		else
			return false
		end

	end
end