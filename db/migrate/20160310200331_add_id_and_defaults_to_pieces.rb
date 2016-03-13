class AddIdAndDefaultsToPieces < ActiveRecord::Migration
  def change
  	add_column :pieces, :tile_id, :string
  	change_column_default :pieces, :has_moved, false
  	change_column_default :pieces, :is_selected, false
  	remove_column :pieces, :is_captured
  end
end
