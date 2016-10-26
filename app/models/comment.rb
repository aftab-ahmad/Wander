class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :city

  validates :message, presence: true
  validates :id, presence: true
end
