class CreateTopicReads < ActiveRecord::Migration
  def change
    create_table :topic_reads do |t|
      t.references :user, index: true
      t.references :topic, index: true

      t.timestamps null: false
    end
    add_foreign_key :topic_reads, :users
    add_foreign_key :topic_reads, :topics
  end
end
