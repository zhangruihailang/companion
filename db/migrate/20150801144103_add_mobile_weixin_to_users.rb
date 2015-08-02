class AddMobileWeixinToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mobile, :string
    add_column :users, :weixin_id, :string
  end
end
