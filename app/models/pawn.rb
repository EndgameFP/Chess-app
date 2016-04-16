class Pawn < Piece

	def is_valid?(dest_x, dest_y)
		dx = (self.x_position - dest_x).abs
		dy = (self.y_position - dest_y).abs

		# White pawns can only move up the board into lower numbered rows
		return false if self.user_id == self.game.white_player_id && dest_x > self.x_position 

		# Black pawns can only move down the board into higher numbered rows
		return false if self.user_id == self.game.black_player_id && dest_x < self.x_position

		# Pawns can move a maximum of one square diagonally or two squares forward
		return false if dy > 1 || dx > 2 || (dy == 1 && dx != 1)

		# Pawns can move a maximum of one square diagonally and only when capturing
		piece_at_dest = self.game.pieces.where(x_position: dest_x, y_position: dest_y).first
		return false if dy == 1 && (!piece_at_dest.present? && !can_en_passant?(dest_x, dest_y))

		# Pawns can't capture when moving vertically
		return false if dy == 0 && piece_at_dest.present?

		# Pawns can only move two squares forward on their first move
		return false if has_moved && dx == 2 

		return true
	end


	def can_en_passant?(dest_x, dest_y)
		return false if self.game.last_move.empty?

		last_piece_moved = self.game.pieces.where(id: self.game.last_move[0]).first
		prev_x = self.game.last_move[1]
		prev_y = self.game.last_move[2]

		if last_piece_moved.x_position > prev_x
			mid_x = prev_x + 1
		else 
			mid_x = prev_x - 1 
		end 

		return true if last_piece_moved.type == "Pawn" && (last_piece_moved.x_position - prev_x).abs == 2 && dest_x == mid_x && dest_y == prev_y
		return false
	end

	def white_pawn
		return true if self.type == 'Pawn' && self.color == 'white'
	end

	def black_pawn
		return true if self.type == 'Pawn' && self.color == 'black'
	end

	def can_promote
		return true if self.x_position == 1 && white_pawn == true
		return true if self.x_position == 8 && black_pawn == true
	end

	def pawn_promote
		if self.white_pawn == true && self.can_promote == true
			self.update_attributes(type: 'Queen', image: "white_queen.png")
		elsif self.black_pawn == true && self.can_promote == true
			self.update_attributes(type: 'Queen', image: "black_queen.png")
		end
	end

end

