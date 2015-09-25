class CreateGoodLikes < ActiveRecord::Migration
  def change
    create_table :good_likes do |t|
      t.references :user, index: true
      t.references :good, index: true

      t.timestamps null: false
    end
    add_foreign_key :good_likes, :users
    add_foreign_key :good_likes, :goods
  end
end
