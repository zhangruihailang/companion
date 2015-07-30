class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :project, index: true
      t.string :file

      t.timestamps null: false
    end
    #add_foreign_key :attachments, :projects
    #add_index :attachments,:project_id
  end
end
