class Followings < ActiveRecord::Base
  attr_accessible :blocked, :follower_id, :user_id

  belongs_to :user
  belongs_to :follower, :class_name => 'User'

end
