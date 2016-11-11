class RemoveImageFromCity < ActiveRecord::Migration
  def change
    remove_attachment :cities, :image
  end
end
