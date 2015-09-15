class CreateActivityApplies < ActiveRecord::Migration
  def change
    create_table :activity_applies do |t|
      t.integer :apply_user_id
      t.references :activity, index: true

      t.timestamps null: false
    end
    add_foreign_key :activity_applies, :activities
  end
end
