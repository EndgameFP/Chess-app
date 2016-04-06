class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # see http://guides.rubyonrails.org/association_basics.html#has-many-association-reference
  has_many :white_games, class_name: 'Game', foreign_key: :white_player_id
  has_many :black_games, class_name: 'Game', foreign_key: :black_player_id
  has_many :pieces

  def games
    white_games + black_games
  end

  def self.current
    Thread.current[:user]
  end
  
  def self.current=(user)
    Thread.current[:user] = user
  end
end
