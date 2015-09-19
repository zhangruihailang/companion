class CreateUserComments < ActiveRecord::Migration
  def change
    create_table :user_comments do |t|
      t.references :user, index: true
      t.integer :post_user_id
      t.text :content

      t.timestamps null: false
    end
    add_foreign_key :user_comments, :users
  end
end
