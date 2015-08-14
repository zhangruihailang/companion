class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
  validates :amount,presence:{message:'不能为空'}
  #validates :income, presence: true , :message => "金额必须为数字！"
  validates :amount,numericality:{message:'必须为数字！'}
end
