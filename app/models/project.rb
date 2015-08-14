class Project < ActiveRecord::Base
  has_many :attachments
  has_many :orders
  
  default_scope -> { order('created_at DESC') }
end
