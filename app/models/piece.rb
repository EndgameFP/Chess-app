class Piece < ActiveRecord::Base
	belongs_to :game
	belongs_to :user

	def is_obstructed?(x, y)

	end
end
