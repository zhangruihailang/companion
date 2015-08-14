class Project < ActiveRecord::Base
  has_many :attachments
  has_many :orders
end
