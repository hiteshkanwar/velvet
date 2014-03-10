ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
   :port                 => 587,
   :domain               => 'gmail',
   :user_name            => 'prateekyuvasoft101@gmail.com',
   :password             => 'yuvasoft2013',
   :authentication       => 'plain',
   :enable_starttls_auto => true 
}
ActionMailer::Base.delivery_method ||= :smtp
