class CreateChannelClasses < ActiveRecord::Migration
  def change
    create_table :channel_classes do |t|
      t.string :title
      t.string :intro
      t.string :picture

      t.timestamps null: false
    end
  end
end
