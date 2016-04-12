class Piece < ActiveRecord::Base
	after_save :update_game_turn

	attr_accessor :wpid
	attr_accessor :bpid
	belongs_to :game
	belongs_to :user


	def make_move(x,y)
		piece_at_dest = piece_at(x,y)
		#return { valid:false } if !moving_own_piece?
	   # return { valid:false } if !player_turn
		return { valid:false } if !is_valid?(x,y) || self.is_obstructed?(x, y) 

		prev_x = self.x_position
		prev_y = self.y_position
		self.update_attributes(:x_position => x, :y_position => y) # Must update position to accurately test for check
		
		own_king = self.game.pieces.where(user_id: self.user_id, type: "King").first
		if check(own_king).count != 0 # Can't move and expose own king to check- this statement evaluates to true if there is a threat to the king
			self.update_attributes(:x_position => prev_x, :y_position => prev_y) #Return moved piece to original position
			puts "CAN'T PUT OWN KING IN CHECK"
			return { valid:false }
		end

		opponent_king = self.game.pieces.where("user_id != ? AND type = ?", self.user_id, "King").first
		threats_to_king = check(opponent_king) # Returns array of all pieces putting king in check, which will be used for checkmate
		if !threats_to_king.empty? # Evaluates true if there is a piece(s) threatening the king
			puts 'CHECK'
			puts "CHECKMATE" if checkmate(opponent_king, threats_to_king)
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
		pieces_at = self.game.pieces.where(x_position: x, y_position: y)

		# If there are multiple pieces at this location, return the opposing piece for accurate testing
		pieces_at.each do |piece|
			return if piece.user_id != self.user_id
		end
		return pieces_at.first
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

	def checkmate(king, threats)
		# Test to see if king can move out of check
		can_move = true
		opponent_pieces = self.game.pieces.where("user_id != ?", king.user_id)
		kings_x = king.x_position
		kings_y = king.y_position

		for row in -1..1 
			for col in -1..1
				new_x = king.x_position + row 
				new_y = king.y_position + col 
				if new_x > 0 && new_x < 9 && new_y > 0 && new_y < 9 # Prevents king from moving off board
					if !king.is_obstructed?(new_x, new_y) # Prevents king from moving onto tile occupied by friendly piece
						king.update_attributes(:x_position => new_x, :y_position => new_y) # Must update coords to accurately test oppenent pieces
						opponent_pieces.each do |piece| # Checks to see if any opponent piece can capture the king in new position
							can_move = false if piece.is_valid?(new_x, new_y) && !piece.is_obstructed?(new_x, new_y)
						end
						king.update_attributes(:x_position => kings_x, :y_position => kings_y)
						return false if can_move == true # If no piece can capture the king in new position, king isn't in checkmate
						can_move = true
					end
				end
			end
		end

		return true if threats.count > 1 # If king can't move out of check, king is in checkmate because multiple threats can't be blocked/captured at same time
			
		# Test to see if friendly piece can capture the threat to the king
		threat = threats[0]
		threats_x = threat.x_position
		threats_y = threat.y_position
 		friendly_pieces = self.game.pieces.where(user_id: king.user_id)

		friendly_pieces.each do |piece| # See if any piece can capture threat
			if piece.is_valid?(threats_x, threats_y) && !piece.is_obstructed?(threats_x, threats_y)
				# If the piece can capture, test piece at new location to ensure king isn't exposed to check by moving
				prev_x = self.x_position
				prev_y = self.y_position
				self.update_attributes(:x_position => threats_x, :y_position => threats_y) 
				new_threats = check(king)
				self.update_attributes(:x_position => prev_x, :y_position => prev_y) 
				return false if new_threats.count == 0
			end

		end

		return true if threat.type == "Knight" # If threat is a Knight, it can't be obstructed, and thus can't be blocked

		# Test to see if any friendly piece can block the threat
		kings_x = king.x_position
		kings_y = king.y_position
		dx = (kings_x - threats_x).abs
		dy = (kings_y - threats_y).abs

		# Must determine which coord has a greater value, because loops can't decrement
		# Use +/- 1 to eliminate the location of the threat and the king, which have already been tested

		if kings_x > threats_x
			top = kings_x - 1
			bottom = threats_x + 1
		else
			top = threats_x - 1
			bottom = kings_x + 1
		end

		if kings_y > threats_y
			right = kings_y - 1
			left = threats_y + 1 
		else
			right = threats_y - 1
			left = kings_y + 1
		end

		for x in bottom..top
			for y in left..right
				friendly_pieces.each do |piece|
					# Tests squares depending on if the attack is horizontal, vertical, or diagonal
					if (dx == 0 && kings_x - x == 0) || (dy == 0 && kings_y - y == 0) || (dx == dy && (kings_y - y).abs == (kings_x - x).abs)
						if piece.is_valid?(x, y) && !piece.is_obstructed?(x, y)
							# If the piece can block, test to see if moving piece exposes king to check
							prev_x = self.x_position
							prev_y = self.y_position
							self.update_attributes(:x_position => x, :y_position => y) 
							new_threats = check(king)
							self.update_attributes(:x_position => prev_x, :y_position => prev_y) 
							return false if new_threats.count == 0
						end
					end
				end
			end
		end

		return true
	end


 	def is_obstructed?(dest_x, dest_y)
 		# Checks to see if friendly piece is at destination tile
 		# Will not return true if destination is occupied by enemy piece
 		return true if self.x_position == dest_x && self.y_position == dest_y
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
