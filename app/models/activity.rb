class Activity < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  after_create :send_email_notification


  def send_email_notification
  	
  	# Check if notification is allowed 
  	#begin
	  	case true
	  	when self.description.downcase.include?("admire") 		&& self.user.noti_admire
	  		# UserMailer.notification(self.user, self).deliver
	  	when self.description.downcase.include?("message")  	&& self.user.noti_message
	  		UserMailer.notification(self.user, self).deliver
	  	when self.description.downcase.include?("retip") 		&& self.user.noti_retips
	  		UserMailer.notification(self.user, self).deliver
	  	when self.description.downcase.include?("acquainted") 	&& self.user.noti_follow
	  		puts "Sending aquaint email"
	  		UserMailer.notification(self.user, self).deliver
	  	when self.description.downcase.include?("mention") 		&& self.user.noti_mention
	  		
	  	end
  	#rescue => error
  	#	puts error.message

  	#end
  end
end
