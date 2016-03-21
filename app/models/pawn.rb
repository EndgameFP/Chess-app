class Pawn < Piece
	def is_valid?(x, y)
		return false if is_obstructed?(x, y)
		#more logic goes here
		return true
	end
end