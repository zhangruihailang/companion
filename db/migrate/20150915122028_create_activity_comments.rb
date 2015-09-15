class CreateActivityComments < ActiveRecord::Migration
  def change
    create_table :activity_comments do |t|
      t.integer :post_user_id
      t.references :activity, index: true

      t.timestamps null: false
    end
    add_foreign_key :activity_comments, :activities
  end
end
