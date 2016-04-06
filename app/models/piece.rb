class Piece < ActiveRecord::Base
	after_save :update_game_turn

	attr_accessor :wpid
	attr_accessor :bpid
	belongs_to :game
	belongs_to :user


	def make_move(x,y)
		piece_at_dest = piece_at(x,y)
	    return { valid:false } if !moving_own_piece?
	    return { valid:false } if !player_turn
		return { valid:false } if !is_valid?(x,y)
 		return { valid:true, captured:piece_at_dest } if piece_at_dest && piece_at_dest.user_id != self.user_id
		return { valid:false } if self.is_obstructed?(x, y) && self.type != "knight"
		

		if self.type == "Pawn" && self.can_en_passant?(x,y)
			captured_pawn = self.game.pieces.where(id: self.game.last_move[0]).first
			self.game.set_last_move(self.id, self.x_position, self.y_position)
			return { valid:true, captured:captured_pawn } 
		end
		
		self.game.set_last_move(self.id, self.x_position, self.y_position)
		return { valid:true }
	end
	
	def update_game_turn
		self.game.bpid if self.color == 'white'
		self.game.wpid if self.color == 'black'
	end

	def player_turn
		user_id == game.turn_player_id
	end

	def moving_own_piece?
   		self.color == 'white' && User.current.id == game.white_player_id ||
    	self.color == 'black' && User.current.id == game.black_player_id
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
