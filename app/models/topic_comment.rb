class TopicComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  
  has_many :topic_comment_likes, dependent: :destroy
  
  def like(like_user_id)
    topic_comment_likes.create(user_id: like_user_id)
  end
  
  def unlike(like_user_id)
    topic_comment_likes.find_by(user_id: like_user_id).destroy
  end
end
