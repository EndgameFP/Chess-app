class AddUserAndGameIdToPieces < ActiveRecord::Migration
  def change
  	add_column :pieces, :user_id, :integer
  	add_column :pieces, :game_id, :integer
  	add_column :pieces, :image, :string
  end
end
