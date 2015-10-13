class ChannelClass < ActiveRecord::Base
  has_many :channels
  mount_uploader :picture, ImageUploader

end
