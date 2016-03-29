class King < Piece
def is_valid?(dest_x, dest_y)
 		dx = dest_x - self.x_position
  		dy = dest_y - self.y_position
 		
 		return true if dx.abs == 1 && dy.abs == 0 || dx.abs == 0 && dy.abs == 1 || dx.abs == 1 && dy.abs == 1
 		return false
  	end
end