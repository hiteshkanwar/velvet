ActionMailer::Base.smtp_settings = {
  :address        => 'smtpout.secureserver.net',
  :port           => '80',
  :authentication => :plain,
  :user_name      => "NoReply@TippinTheVelvet.com",
  :password       => "Mylifesucks2",
  :domain         => 'heroku.com'
}
ActionMailer::Base.delivery_method ||= :smtp
  