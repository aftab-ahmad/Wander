class User < ActiveRecord::Base
  has_many :comments
  has_many :cities, :through => :comments

  has_and_belongs_to_many :followers,
                          class_name: 'User',
                          join_table: :followers,
                          foreign_key: :follower_id,
                          association_foreign_key: :user_id
end
