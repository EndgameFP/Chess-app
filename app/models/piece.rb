class Piece < ActiveRecord::Base
	belongs_to :game
	belongs_to :user

	def make_move(x,y)

		piece_at_dest = piece_at(x,y)
		return { valid:false } if !is_valid?(x,y)
 		return { valid:true, captured:piece_at_dest } if piece_at_dest && piece_at_dest.user_id != self.user_id
		return { valid:false } if self.is_obstructed?(x, y) && self.type != "knight"
		
		return { valid:true }
	end
	
	def piece_at(x,y)
		return self.game.pieces.where(x_position: x, y_position: y).first
	end

 	def is_obstructed?(dest_x, dest_y)
 		# Checks to see if friendly piece is at destination tile
 		# Will not return true if destination is occupied by enemy piece
 		piece_at_dest = piece_at(dest_x,dest_y)
 		return true if piece_at_dest && piece_at_dest.user_id == self.user_id

 		# Assigns y values according to col position on board	
	 	if y_position > dest_y
			left = dest_y
			right = y_position
		else
			left = y_position
			right = dest_y
		end

		# Assigns x values according to row position
		if x_position > dest_x
			top = x_position
			bottom = dest_x
		else
			top = dest_x
			bottom = x_position
		end

 		if (self.x_position - dest_x) == 0 #Piece is moving horizontally
 			pieces_in_row = self.game.pieces.where("x_position = ?", self.x_position)
 			pieces_in_row.each do |piece|
 				return true if piece.y_position > left && piece.y_position < right
 			end

		elsif (self.y_position - dest_y) == 0 #Piece is moving vertically			
			pieces_in_col = self.game.pieces.where("y_position = ?", self.y_position)
 			pieces_in_col.each do |piece|
 				return true if piece.x_position < top && piece.x_position > bottom
 			end
		
		elsif (x_position - dest_x).abs == (y_position - dest_y).abs #Slope == 1, so moving diagonally
			self.game.pieces.each do |piece|
				if (x_position - piece.x_position).abs == (y_position - piece.y_position).abs # Piece is on same line
					return true if piece.x_position < top && piece.x_position > bottom && piece.y_position > left && piece.y_position < right 
				end
			end
		end
		return false
    end


	def is_valid?(x,y)
		# Template for each model's definition
	end
end
