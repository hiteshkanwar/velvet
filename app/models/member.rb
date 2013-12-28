class Member < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :list
  belongs_to :user
end
