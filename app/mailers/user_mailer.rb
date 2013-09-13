class UserMailer < ActionMailer::Base
   
  def welcome_email(user)
    
    @user = user

    mail(
        :subject => "Welcome to Tippin The Velvet",
        :to      => @user.email,
        :from    => "Tippin The Velvet <no-reply@tippinthevelvet.com>",
        :tag     => "Welcome"
      )
  end

  def forgot_password_email(user)
    
    @user = user

    mail(
        :subject => "Forgot password",
        :to      => @user.email,
        :from    => "Tippin The Velvet <support@tippinthevelvet.com>",
        :tag     => "Forgot"
      )
  end
 
end
