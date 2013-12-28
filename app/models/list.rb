class List < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :members
  belongs_to :user

  def add_user(user)
  	self.members.create(user: user)
  end

end
