class TopicCommentLike < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic_comment
end
