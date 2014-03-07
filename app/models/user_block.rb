class UserBlock < ActiveRecord::Base
  belongs_to :user
  attr_accessible :blocked_id,:user_id
end
