class Game < ActiveRecord::Base
	has_many :pieces
	belongs_to :user

	validates :name, presence: true

	def set_up_game
		for col in 1..8 
			Pawn.create(user_id: black_player_id, x_position: 2, y_position: col, image: "black_pawn.png", game_id: self.id)
			Pawn.create(user_id: white_player_id, x_position: 7, y_position: col, image: "white_pawn.png", game_id: self.id)

			case col
			when 1, 8
				Rook.create(user_id: white_player_id, x_position: 8, y_position: col, image: "white_rook.png", game_id: self.id)
				Rook.create(user_id: black_player_id, x_position: 1, y_position: col, image: "black_rook.png", game_id: self.id)
			when 2, 7	
				Knight.create(user_id: white_player_id, x_position: 8, y_position: col, image: "white_knight.png", game_id: self.id)
				Knight.create(user_id: black_player_id, x_position: 1, y_position: col, image: "black_knight.png", game_id: self.id)	
			when 3, 6
				Bishop.create(user_id: white_player_id, x_position: 8, y_position: col, image: "white_bishop.png", game_id: self.id)
				Bishop.create(user_id: black_player_id, x_position: 1, y_position: col, image: "black_bishop.png", game_id: self.id)
			when 4
				Queen.create(user_id: white_player_id, x_position: 8, y_position: col, image: "white_queen.png", game_id: self.id)
				Queen.create(user_id: black_player_id, x_position: 1, y_position: col, image: "black_queen.png", game_id: self.id)
			when 5 
				King.create(user_id: white_player_id, x_position: 8, y_position: col, image: "white_king.png", game_id: self.id)
				King.create(user_id: black_player_id, x_position: 1, y_position: col, image: "black_king.png", game_id: self.id)
			end

		end
	end
end