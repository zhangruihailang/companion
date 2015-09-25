class CreateGoodComments < ActiveRecord::Migration
  def change
    create_table :good_comments do |t|
      t.text :content
      t.references :user, index: true
      t.references :good, index: true

      t.timestamps null: false
    end
    add_foreign_key :good_comments, :users
    add_foreign_key :good_comments, :goods
  end
end
