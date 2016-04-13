class AddLastMoveToGame < ActiveRecord::Migration
  def change
  	add_column :games, :last_move, :integer, array:true, default: []
  end
end
