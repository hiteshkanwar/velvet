class HashTag < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :post

  def self.trending
  	self.order("count DESC").limit(10)
  end

end
