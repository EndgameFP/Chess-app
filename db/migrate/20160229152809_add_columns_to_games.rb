class AddColumnsToGames < ActiveRecord::Migration
  def change
  	add_column :games, :name, :string
  	add_column :games, :status, :string
  	add_column :games, :white_player_id, :integer
  	add_column :games, :black_player_id, :integer
  	add_column :games, :turn_player_id, :integer

  end
end
