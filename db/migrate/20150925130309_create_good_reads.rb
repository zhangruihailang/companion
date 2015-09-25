class CreateGoodReads < ActiveRecord::Migration
  def change
    create_table :good_reads do |t|
      t.references :user, index: true
      t.references :good, index: true

      t.timestamps null: false
    end
    add_foreign_key :good_reads, :users
    add_foreign_key :good_reads, :goods
  end
end
