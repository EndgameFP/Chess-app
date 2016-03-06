class DropJoinsTable < ActiveRecord::Migration
  def change
  	drop_table :joins
  end
end
