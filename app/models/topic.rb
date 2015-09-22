class Topic < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :channel
  
  has_many :topic_pics, dependent: :destroy
  has_many :topic_comments, dependent: :destroy
  has_many :topic_likes, dependent: :destroy
  has_many :topic_reads, dependent: :destroy
  
  def like(like_user_id)
    topic_likes.create(user_id: like_user_id)
  end
  
  def unlike(like_user_id)
    topic_likes.find_by(user_id: like_user_id).destroy
  end
end
