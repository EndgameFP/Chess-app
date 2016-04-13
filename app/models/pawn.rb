class Pawn < Piece

	def is_valid?(dest_x, dest_y)
		dx = (self.x_position - dest_x).abs
		dy = (self.y_position - dest_y).abs

		# # White pawns can only move up the board into lower numbered rows
		# return false if self.user_id == self.game.white_player_id && dest_x > self.x_position 

		# # Black pawns can only move down the board into higher numbered rows
		# return false if self.user_id == self.game.black_player_id && dest_x < self.x_position

		# # Pawns can move a maximum of one square diagonally or two squares forward
		# return false if dy > 1 || dx > 2 || (dy == 1 && dx != 1)

		# # Pawns can move a maximum of one square diagonally and only when capturing
		# piece_at_dest = self.game.pieces.where(x_position: dest_x, y_position: dest_y).first
		# return false if dy == 1 && !piece_at_dest.present?

		# # Pawns can't capture when moving vertically
		# return false if dy == 0 && piece_at_dest.present?

		# # Pawns can only move two squares forward on their first move
		# return false if has_moved && dx == 2 
		return true
	end


end
