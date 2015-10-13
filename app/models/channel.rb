class Channel < ActiveRecord::Base
  belongs_to :user
  has_many :topics
  belongs_to :channel_class
  mount_uploader :picture, ImageUploader
  
end
