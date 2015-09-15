class AddConentToActivityComments < ActiveRecord::Migration
  def change
    add_column :activity_comments, :content, :text
  end
end
