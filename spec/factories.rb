FactoryGirl.define do
	factory :user, aliases: [:white_player, :black_player] do
		sequence :email do |n|
			"test#{n}@test.com"
		end
		password 'secretPassword'
		password_confirmation 'secretPassword'
	end

	factory :game do
		name "Rival"
		white_player

	end

	# factory :piece do

	# 	factory :pawn do
	# 		type "pawn"
	# 	end

	# 	factory :rook do
	# 		type "rook"
	# 	end

	# 	factory :knight do
	# 		type "knight"
	# 	end

	# 	factory :bishop do
	# 		type "bishop"
	# 	end

	# 	factory :queen do
	# 		type "queen"
	# 	end

	# 	factory :king do
	# 		type "king"
	# 	end
	# end
end