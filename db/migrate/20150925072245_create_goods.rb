class CreateGoods < ActiveRecord::Migration
  def change
    create_table :goods do |t|
      t.string :title
      t.string :description
      t.float :price
      t.float :original_price
      t.float :freight
      t.references :user, index: true
      t.references :good_class, index: true

      t.timestamps null: false
    end
    add_foreign_key :goods, :users
    add_foreign_key :goods, :good_classes
  end
end
