class AddTypeToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :type, :string
  end
end
