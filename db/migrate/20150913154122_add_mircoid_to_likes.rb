class AddMircoidToLikes < ActiveRecord::Migration
  def change
    add_reference :likes, :micropost, index: true
    add_foreign_key :likes, :microposts
  end
end
