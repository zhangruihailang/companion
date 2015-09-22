class CreateTopicCommentLikes < ActiveRecord::Migration
  def change
    create_table :topic_comment_likes do |t|
      t.references :user, index: true
      t.references :topic_comment, index: true

      t.timestamps null: false
    end
    add_foreign_key :topic_comment_likes, :users
    add_foreign_key :topic_comment_likes, :topic_comments
  end
end
