class GoodPic < ActiveRecord::Base
  belongs_to :good
  
  mount_uploader :file, ImageUploader
end
