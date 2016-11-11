class City < ActiveRecord::Base
  has_many :comments
  has_many :users, :through => :comments

  validates :name, presence: true
  validates :id, presence: true
end
