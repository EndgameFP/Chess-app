class CreateJoins < ActiveRecord::Migration
  def change
    create_table :joins do |t|
    	t.integer :user_id
    	t.integer :game_id

      t.timestamps null: false
    end
    add_index :joins, [:user_id, :game_id]
  	add_index :joins, :game_id
  end
end
