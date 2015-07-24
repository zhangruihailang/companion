class AddAvatarsToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :avatars, :json
  end
end
