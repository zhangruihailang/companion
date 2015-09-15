class ActivityPic < ActiveRecord::Base
  belongs_to :activity
  
  default_scope -> { order(created_at: :desc) }
  mount_uploader :file, ImageUploader
  validates :activity_id, presence: true
end
