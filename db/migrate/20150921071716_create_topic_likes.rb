class CreateTopicLikes < ActiveRecord::Migration
  def change
    create_table :topic_likes do |t|
      t.references :user, index: true
      t.references :topic, index: true

      t.timestamps null: false
    end
    add_foreign_key :topic_likes, :users
    add_foreign_key :topic_likes, :topics
  end
end
