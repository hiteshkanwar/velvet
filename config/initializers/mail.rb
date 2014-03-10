ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.gmail.com',
  :port           => '587',
  :authentication => :plain,
  :user_name      => "prateekyuvasoft101@gmail.com",
  :password       => "yuvasoft2013",
  :domain         => 'heroku.com'
}
ActionMailer::Base.delivery_method ||= :smtp
  