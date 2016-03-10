class Piece < ActiveRecord::Base
	belongs_to :game
	belongs_to :user
	def self.types
      %w(Pawn Rook Knight Bishop Queen King)
    end
end
