class CreateSmscodes < ActiveRecord::Migration
  def change
    create_table :smscodes do |t|
      t.string :mobile
      t.string :code

      t.timestamps null: false
    end
  end
end
