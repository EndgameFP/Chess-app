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
		return { valid:false } if !is_valid?(x,y) || self.is_obstructed?(x, y) 

		prev_x = self.x_position
		prev_y = self.y_position
		self.update_attributes(:x_position => x, :y_position => y) # Must update position to accurately test for check
		
		if !check(own_king).empty? # Can't move and expose own king to check- this statement evaluates to true if there is a threat to the king
			self.update_attributes(:x_position => prev_x, :y_position => prev_y) #Return moved piece to original position
			return { valid:false }
		end

		opponent_king = self.game.pieces.where("user_id != ? AND type = ?", self.user_id, "King").first
		threats_to_king = check(opponent_king) # Returns array of all pieces putting king in check, which will be used for checkmate
		if !threats_to_king.empty? # Evaluates true if there is a piece(s) threatening the king
			puts 'CHECK'
			#test for checkmate, pass threats and king as params
			#if in checkmate, end game
			#else announce check 
		end 

		self.update_attribute(:has_moved, true)

		return { valid:true, captured:piece_at_dest } if piece_at_dest && piece_at_dest.user_id != self.user_id
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

	def check(king)
		opponent_pieces = self.game.pieces.where("user_id != ?", king.user_id)
		threats = [] # Must collect all pieces that threaten the king to use when testing for checkmate
		opponent_pieces.each do |piece|
			# Tests if any opponent piece can legally move to the king's position (and capture it)
			if piece.is_valid?(king.x_position, king.y_position) && !piece.is_obstructed?(king.x_position, king.y_position) 
				threats << piece	
			end
		end
		return threats
	end 


 	def is_obstructed?(dest_x, dest_y)
 		# Checks to see if friendly piece is at destination tile
 		# Will not return true if destination is occupied by enemy piece
 		piece_at_dest = piece_at(dest_x,dest_y)
 		return true if piece_at_dest && piece_at_dest.user_id == self.user_id

 		# Returns false if piece is Knight, since knights can't be obstructed
 		return false if self.type == "Knight"

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
