class Activity < ActiveRecord::Base
  belongs_to :user
  has_many :activity_pics , dependent: :destroy
  has_many :activity_comments,dependent: :destroy
  has_many :activity_applies , dependent: :destroy
  #attr_accessor :id
  def apply(apply_user_id)
    activity_applies.create(:apply_user_id => apply_user_id)
  end
  
  def has_applied?(apply_user_id)
    apply = ActivityApply.find_by(:apply_user_id => apply_user_id,:activity_id => self.id)
    !apply.nil?
  end
end
