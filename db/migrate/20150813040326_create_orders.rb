class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.references :project, index: true
      t.integer :amount

      t.timestamps null: false
    end
    add_foreign_key :orders, :users
    add_foreign_key :orders, :projects
  end
end
