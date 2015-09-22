class Category < ActiveRecord::Base
  # has_many :categories, class_name: "Category",
  #                           foreign_key: "parent_id",
  #                           dependent: :destroy
  has_many :posts
  has_many :topics
end
