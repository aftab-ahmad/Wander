class City < ActiveRecord::Base
  has_many :comments
  has_many :users, :through => :comments

  has_attached_file :image, styles: { small: '240x320', med: '320x480', large: '480x800', xlarge: '640x960'},
                    :default_url => 'http://payload240.cargocollective.com/1/7/247965/7115182/b5a7381a1dfdce9cd7f3315db52bb90f.jpg'

  validates :name, presence: true
  validates :id, presence: true
end
