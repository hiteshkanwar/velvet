class ApplicationController < ActionController::Base
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
  
    def confirm_logged_in
      unless session[:email]
        redirect_to :root
        return false
      else
      	@current_user = User.find_by_email(session[:email])
      	#@current_user = User.first
        return true
      end
  	end
  	
end
