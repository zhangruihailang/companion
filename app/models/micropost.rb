class Micropost < ActiveRecord::Base
  belongs_to :user
  has_many :message_pics, dependent: :destroy
  
  has_many :likeds, class_name: "Like",
          dependent: :destroy
  
  has_many :post_comments,dependent: :destroy
  # has_many:passive_likes, class_name: "Like",
  #         foreign_key: "to_user_id",
  #         dependent: :destroy
  #has_many:likers, through: :active_likes, source: "to_user_id"
  #has_many:likeds, through: :passive_likes, source: "from_user_id"
  
  default_scope -> { order(created_at: :desc) }
  #mount_uploader :picture, PictureUploader
  mount_uploaders :avatars, PictureUploader
  validates :user_id, presence: true
  #validates :content, presence: true, length: { maximum: 140 }
  #validate :picture_size
  
  
  
  def like(from_id,to_id)
    likeds.create(from_user_id: from_id,to_user_id: to_id)
  end
  
  def unlike(from_id)
    likeds.find_by(from_user_id: from_id).destroy
  end
  
  def has_liked_by_current_user?(user)
    likeds.include?(user)  
  end
  
  private
    # 验证图片大小
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:avatars, "should be less than 5MB")
      end
    end
end
