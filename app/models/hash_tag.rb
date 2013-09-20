class HashTag < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :post

  def trending
  	self.order("hast_tags.count DESC").limit(10)
  end

end
