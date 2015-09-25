class CreateGoodPics < ActiveRecord::Migration
  def change
    create_table :good_pics do |t|
      t.string :file
      t.references :good, index: true

      t.timestamps null: false
    end
    add_foreign_key :good_pics, :goods
  end
end
