class AddAvatarsToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :avatars, :string
  end
end
