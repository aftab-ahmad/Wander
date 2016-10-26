class AddImageToCity < ActiveRecord::Migration
  def change
    add_attachment :cities, :image
  end
end
