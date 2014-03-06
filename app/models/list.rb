class List < ActiveRecord::Base
  attr_accessible :name, :description, :is_public
  has_many :members
  has_many :subscribe_and_invitations, :dependent => :destroy

  belongs_to :user

  def add_user(user)
  	self.members.create(user: user)
  end

end
