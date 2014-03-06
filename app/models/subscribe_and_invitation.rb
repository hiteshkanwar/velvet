class SubscribeAndInvitation < ActiveRecord::Base
  belongs_to :list
  belongs_to :user
  attr_accessible :subscribe ,:list_id, :user_id 
end
