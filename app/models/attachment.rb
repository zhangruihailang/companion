class Attachment < ActiveRecord::Base
  belongs_to :project
  default_scope -> { order(created_at: :desc) }
  #mount_uploader :picture, PictureUploader
  #mount_uploader :file, ProjectPicUploader
  mount_uploader :file, ImageUploader
  validates :project_id, presence: true
end
