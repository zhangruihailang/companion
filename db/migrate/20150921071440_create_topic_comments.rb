class CreateTopicComments < ActiveRecord::Migration
  def change
    create_table :topic_comments do |t|
      t.references :user, index: true
      t.references :topic, index: true
      t.text :content

      t.timestamps null: false
    end
    add_foreign_key :topic_comments, :users
    add_foreign_key :topic_comments, :topics
  end
end
