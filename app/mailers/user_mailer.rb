class UserMailer < ActionMailer::Base
   
  def welcome_email(user)
    
    @user = user

    mail(
        :subject => "Welcome to Tippin The Velvet",
        :to      => @user.email,
        :from    => "Tippin The Velvet <admin@tipinthevelvet.com>",
        :tag     => "Welcome"
      )
  end

  def forgot_password_email(user)
    
    @user = user

    mail(
        :subject => "Forgot password",
        :to      => @user.email,
        :from    => "Tippin The Velvet <admin@tipinthevelvet.com>",
        :tag     => "Forgot"
      )
  end
 
end
