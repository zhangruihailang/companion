class AddClassToChannels < ActiveRecord::Migration
  def change
    add_reference :channels, :channel_class, index: true
    add_foreign_key :channels, :channel_classes
  end
end
