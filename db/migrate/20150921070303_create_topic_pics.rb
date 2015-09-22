class CreateTopicPics < ActiveRecord::Migration
  def change
    create_table :topic_pics do |t|
      t.string :file
      t.references :topic, index: true

      t.timestamps null: false
    end
    add_foreign_key :topic_pics, :topics
  end
end
