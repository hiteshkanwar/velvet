class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers
  protect_from_forgery

    protected
    def _set_current_session
      # Define an accessor. The session is always in the current controller
      # instance in @_request.session. So we need a way to access this in
      # our model
      accessor = instance_variable_get(:@_request)

      # This defines a method session in ActiveRecord::Base. If your model
      # inherits from another Base Class (when using MongoMapper or similar),
      # insert the class here.
      ActiveRecord::Base.send(:define_method, "session", proc {accessor.session})
    end

    def generate_activation_code(size = 6)
      charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
      (0...size).map{ charset.to_a[rand(charset.size)] }.join
    end
  
    def confirm_logged_in
      unless session[:email]
        redirect_to :root
        return false
      else
      	current_user
      	#@current_user = User.first
        return true
      end
  	end

    def current_user
      @current_user ||= User.find_by_email(session[:email])
    end
    def serve_ad
      @advertiser  = Advertiser.get_ad()
      @advertiser.ad_is_served  if @advertiser.present?
      @advertiser
    end
  	
end
