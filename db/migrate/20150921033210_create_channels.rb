class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.references :user, index: true
      t.string :title
      t.string :intro
      t.string :picture

      t.timestamps null: false
    end
    add_foreign_key :channels, :users
  end
end
