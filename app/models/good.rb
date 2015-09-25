class Good < ActiveRecord::Base
  belongs_to :user
  belongs_to :good_class
  
  has_many :good_pics, dependent: :destroy
  has_many :good_comments, dependent: :destroy
  has_many :good_likes, dependent: :destroy
  has_many :good_reads,dependent: :destroy
  
  
  def like(like_user_id)
    good_likes.create(user_id: like_user_id)
  end
  
  def unlike(like_user_id)
    good_likes.find_by(user_id: like_user_id).destroy
  end
end
