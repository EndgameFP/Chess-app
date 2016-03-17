class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
    	t.integer :x_position
    	t.integer :y_position
    	t.integer :piece_id
    		

      t.timestamps null: false
    end
  end
end
