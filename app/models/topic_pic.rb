class TopicPic < ActiveRecord::Base
  belongs_to :topic
  
  
  mount_uploader :file, ImageUploader
end
