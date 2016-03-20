class Piece < ActiveRecord::Base
	belongs_to :game
	belongs_to :user

  # NOTE does not check (x, y), only up to x and y, not including
  # NOTE whether (x, y) is a valid move could be checked in another method
	# Check to see if there are any pieces between starting place and ending place
  def is_obstructed?(x,y)
# NOTE this should never be checked in
# i leave these at the margin so they stand out to be removed before committing
binding.pry
   	dx = x_position - x
   	dy = y_position - y
   	if dx.abs == dy.abs
   	  # diagonal
   	  dx = dx / dx.abs
   	  dy = dy / dy.abs
   	  check_x, check_y = x_position, y_position
      while check_x != x
   	    check_x += dx
   	    check_y += dy
binding.pry
   	    return false if false
      end
   	elsif dx == 0
   	  # vertical
   	elsif dy == 0
   	  # horizontal
   	else
   	  # unexpected move - cannot be processed in this method
   	  return false
   	end
  end

 	# 		#is_obstructed? should return true if the destination square contains another of the player's pieces.
	# 		#If the destination square contains an enemy piece, it is not obstructed.
	# 		#Add a test(s) for this functionality, can be in all three directions
	# 		#split into three checks, one for horizontal, one for vertical, one for diagonal.
	# =>    #Will be a shared method on the piece model.

	def valid_move?
	end
end
