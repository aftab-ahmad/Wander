class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.references :user, foreign_key: true
      t.references :follower, foreign_key: true
    end
  end
end
