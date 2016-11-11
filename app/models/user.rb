class User < ActiveRecord::Base
  has_many :comments, :dependent => :destroy
  has_many :cities, :through => :comments, :dependent => :destroy

  has_and_belongs_to_many :followers,
                          class_name: 'User',
                          join_table: :followers,
                          foreign_key: :follower_id,
                          association_foreign_key: :user_id

  validates :name, presence: true
  validates :id, presence: true

end
