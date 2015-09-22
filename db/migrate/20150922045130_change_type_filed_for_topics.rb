class ChangeTypeFiledForTopics < ActiveRecord::Migration
  def change
    rename_column :topics, :type, :topic_type
  end
end
