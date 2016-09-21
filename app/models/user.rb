class User < ActiveRecord::Base
  has_many :comments, :dependent => :destroy
  has_many :cities, :through => :comments, :dependent => :destroy

  has_and_belongs_to_many :followers,
                          class_name: 'User',
                          join_table: :followers,
                          foreign_key: :follower_id,
                          association_foreign_key: :user_id

  has_attached_file :image, styles: { small: '64x64', med: '100x100', large: '200x200' },
      :default_url => 'http://www.m1m.com/wp-content/uploads/2015/06/default-user-avatar.png'

end
