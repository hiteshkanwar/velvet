class Activity < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  after_create :send_email_notification


  def send_email_notification
  	
  	# Check if notification is allowed 
  	case true
  	when 
  	end
  		
  end
end
