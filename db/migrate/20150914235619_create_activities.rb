class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :title
      t.text :description
      t.datetime :starttime
      t.datetime :endtime
      t.string :place
      t.string :number_of_people
      t.string :pay_type
      t.integer :average_cost
      t.references :user, index: true
      t.string :tags
      t.integer :apply_up_limit

      t.timestamps null: false
    end
    add_foreign_key :activities, :users
  end
end
