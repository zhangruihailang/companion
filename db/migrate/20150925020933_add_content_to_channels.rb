class AddContentToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :content, :text
  end
end
