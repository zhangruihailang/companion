class Channel < ActiveRecord::Base
  belongs_to :user
  has_many :topics
  
  mount_uploader :picture, ImageUploader
  
end
