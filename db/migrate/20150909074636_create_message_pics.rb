class CreateMessagePics < ActiveRecord::Migration
  def change
    create_table :message_pics do |t|
      t.string :file
      t.references :micropost, index: true

      t.timestamps null: false
    end
    add_foreign_key :message_pics, :microposts
  end
end
