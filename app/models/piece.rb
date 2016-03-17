class Piece < ActiveRecord::Base
	belongs_to :game
	belongs_to :user
	has_many :moves


 	def is_obstructed?(x,y)
 		piece = Piece.find(self.id)
 		@selected_piece = Piece.find_by_is_selected(true)
 		# x = new_x_position
 		# y = new_y_position
 		# new_tile_id = "#{x-y}"
 		if piece.user_id == @selected_piece.user_id # if two pieces have same user_id, piece is obstructed
 			return true
 		else
 			return false
 		end
 		#user = Piece.find(self.user_id)
		#if #piece.user_id == @selected_piece.user_id#same user id piece can not have same tile id as other piece
		#	return true
		# elsif 
		#self.update_attributes({:x_coord => x_coord, :y_coord => y_coord})
		# 	return true
		#else
			#self.update_attributes(tile_id: tile_id) 
		 	#return false#If the destination square contains an enemy piece, it is not obstructed.
			
	# 		piece.tile_id != piece.tile_id
	# 		#same user id piece can not have same tile id as other piece
		#end


	# 		#is_obstructed? should return true if the destination square contains another of the player's pieces. 
	# 		#If the destination square contains an enemy piece, it is not obstructed.
	# 		#Add a test(s) for this functionality, can be in all three directions
	# 		#Check to see if there are any pieces between starting place and ending place- 
	# 		#split into three checks, one for horizontal, one for vertical, one for diagonal. 
	# =>    #Will be a shared method on the piece model.
    end


	def valid_move?

	end

end
