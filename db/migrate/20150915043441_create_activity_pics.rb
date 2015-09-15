class CreateActivityPics < ActiveRecord::Migration
  def change
    create_table :activity_pics do |t|
      t.string :file
      t.references :activity, index: true

      t.timestamps null: false
    end
    add_foreign_key :activity_pics, :activities
  end
end
