class DropTableMoves < ActiveRecord::Migration
  def change
  	drop_table :moves
  end
end
