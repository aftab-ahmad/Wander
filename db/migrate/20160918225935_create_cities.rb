class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :visitors
      t.integer :favourites

      t.timestamps null: false
    end
  end
end
