class Knight < Piece
	def is_valid?(x, y)
		# No need to call is_obstructed, since knights can jump over pieces
		#more logic goes here
		return true
	end
end