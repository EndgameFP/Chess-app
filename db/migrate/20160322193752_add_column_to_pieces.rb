class AddColumnToPieces < ActiveRecord::Migration
  def change
  	add_column :pieces, :color, :string
  end
end
