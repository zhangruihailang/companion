class AddRongimTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rong_im_token, :string
  end
end
