FactoryGirl.define do
  factory :move do
    
  end
	factory :user do
		sequence :email do |n|
			"test#{n}@test.com"
		end
		password 'secretPassword'
		password_confirmation 'secretPassword'
	end

	factory :game do
		name "Rival"
		
	end

end