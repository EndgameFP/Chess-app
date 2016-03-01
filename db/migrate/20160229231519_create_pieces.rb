class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|
    	t.integer :piece_id
    	t.string :type
    	t.integer :x_position
    	t.integer :y_position
    	t.boolean :has_moved
    	t.boolean :is_captured
    	t.boolean :is_selected


      t.timestamps null: false
    end
  end
end
