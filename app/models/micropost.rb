class Micropost < ActiveRecord::Base
  belongs_to :user
  has_many :message_pics, dependent: :destroy
  
  default_scope -> { order(created_at: :desc) }
  #mount_uploader :picture, PictureUploader
  mount_uploaders :avatars, PictureUploader
  validates :user_id, presence: true
  #validates :content, presence: true, length: { maximum: 140 }
  #validate :picture_size
  
  private
    # 验证图片大小
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:avatars, "should be less than 5MB")
      end
    end
end
