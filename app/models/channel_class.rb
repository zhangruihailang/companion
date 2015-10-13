class ChannelClass < ActiveRecord::Base
  has_many :channels, dependent: :destroy
  mount_uploader :picture, ImageUploader

end
