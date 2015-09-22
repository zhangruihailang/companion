class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.references :user, index: true
      t.references :category, index: true
      t.references :channel, index: true
      t.string :title
      t.text :content

      t.timestamps null: false
    end
    add_foreign_key :topics, :users
    add_foreign_key :topics, :categories
    add_foreign_key :topics, :channels
  end
end
