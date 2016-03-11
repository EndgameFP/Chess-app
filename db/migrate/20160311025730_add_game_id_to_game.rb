class AddGameIdToGame < ActiveRecord::Migration
  def change
  	add_column :games, :game_id, :integer
  end
end
