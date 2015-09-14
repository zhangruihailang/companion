class AddContentToPostComments < ActiveRecord::Migration
  def change
    add_column :post_comments, :content, :text
  end
end
