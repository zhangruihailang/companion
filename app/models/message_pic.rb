class MessagePic < ActiveRecord::Base
  belongs_to :micropost
  
  default_scope -> { order(created_at: :desc) }
  mount_uploader :file, ImageUploader
  validates :micropost_id, presence: true
end
