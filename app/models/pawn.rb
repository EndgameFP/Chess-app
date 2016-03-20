class Pawn < Piece
	def is_valid?(x, y)
		obstructed = is_obstructed?(x, y)
	end
end