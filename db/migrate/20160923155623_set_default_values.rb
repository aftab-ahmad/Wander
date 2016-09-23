class SetDefaultValues < ActiveRecord::Migration
  def change
    change_column :cities, :favourites, :integer, :default => 0
    change_column :cities, :visitors, :integer, :default => 0
    change_column_null :cities, :favourites, false
    change_column_null :cities, :visitors, false
  end
end
