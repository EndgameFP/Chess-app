class Game < ActiveRecord::Base
	has_many :pieces
	belongs_to :user

	validates :name, presence: true
end
