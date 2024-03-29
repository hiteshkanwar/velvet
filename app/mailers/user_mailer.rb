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

  def notification(user, activity)
    @user = user
    @activity = activity
    @person = User.find(activity.person)

    mail(
        :subject => "#{@person.name} #{@activity.description}",
        :to      => @user.email,
        :from    => "Tippin The Velvet <support@tippinthevelvet.com>",
        :tag     => "Forgot"
      )
  end

  def campaign_notification(advertiser)
    @advertiser = advertiser
    mail(
        :subject => "#{@advertiser.full_name} created advertisement",
        :to      => 'ngrichyj4@gmail.com',
        :from    => "Tippin The Velvet <support@tippinthevelvet.com>"
      )
  end
  def payment_failed(advertiser)
    @advertiser = advertiser
    mail(
        :subject => "#{@advertiser.full_name} payment failed",
        :to      => 'support@tippinthevelvet.com',
        :from    => "Tippin The Velvet <support@tippinthevelvet.com>"
      )
  end
end
