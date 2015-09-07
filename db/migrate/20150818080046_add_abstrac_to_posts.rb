class AddAbstracToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :abstract, :text
  end
end
