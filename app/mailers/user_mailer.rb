class UserMailer < ActionMailer::Base
  #:from    => "\"#{@diea.name}\" <admin@planhero.com>"

   
  def welcome_email(user)
    
    @user = user

    mail(
        :subject => "Welcome to Tip in The Velvet",
        :to      => @user.email,
        :from    => "Tip in The Velvet <admin@tipinthevelvet.com>",
        :tag     => "Welcome"
      )
  end

  def forgot_password_email(user)
    
    @user = user

    mail(
        :subject => "Forgot password",
        :to      => @user.email,
        :from    => "Tip in The Velvet <admin@tipinthevelvet.com>",
        :tag     => "Forgot"
      )
  end
 
end
