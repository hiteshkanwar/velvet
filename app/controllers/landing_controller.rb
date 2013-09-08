class LandingController < ApplicationController
	
	layout 'application'
  
  # Views --------------
  def index

  	
  end

  def login
  	render 'login'
  end

  def register
  	render 'register'
  end

  def forgot
  	render 'forgot'
  end

  def confirm_forgot
  	user = User.find_by_email(params[:email])
  	if user && user.forgot_password_token == params[:token]
  		@params = {email: user.email, token: user.forgot_password_token}
  		render 'confirm_forgot'
  	else
  		redirect_to :root
  	end
  	
  end

  def about
  	
  end


  # Controls -----------------
  
  def validate_login

    if User.authenticate(params[:email], params[:password])
    	session[:email] = params[:email]
    	mixpanel.track 'User Signed In', { :distinct_id => params[:email], :time => Time.now.to_datetime }
      
      # If state exists from, accept inviation
      # Redirect to state, else login user
      if session[:state]
        state = session[:state]
        session[:state] = nil
        redirect_to state
      else
        redirect_to :root
    	end

    else
    	flash[:notice] = "Invalid email or password"
    	redirect_to '/login'
    end

  end

  def create

  	 @user = User.new(name: params[:name], email: params[:email], hashed_password: params[:password])
  	 if @user.save

  	 	logger.debug("User created successfuly")
  	 	session[:email] = @user.email

        #=> Send welcome email
        UserMailer.welcome_email(@user).deliver
        
        # If state exists from, accept inviation
        # Redirect to state, else login user
        if session[:state]
          state = session[:state]
          session[:state] = nil
          redirect_to state
        else
          redirect_to :root
        end
        
  	 else
  	 	flash[:notice] = @user.errors.full_messages.to_sentence.gsub(" Hashed", "")
  	 	logger.debug("User not created: #{flash[:notice]}")
  	 	redirect_to '/register'
  	 end
  	 
  end

  def reset
  	user = User.find_by_email(params[:email])
  	if user
  		user.update_attributes(forgot_password_token: SecureRandom.hex(20))
  		# Send confirm email
  		 UserMailer.forgot_password_email(user).deliver
       flash[:notice] = "Please check your email, to reset your password"
       redirect_to '/forgot'
  	else
  		flash[:notice] = "This email address is not registered"
  		redirect_to '/forgot'
  	end

  end

  def confirm_reset
  	user = User.find_by_email(params[:email])
  	if user && user.forgot_password_token == params[:token]
  		user.update_attributes(hashed_password: Digest::SHA1.hexdigest(params[:password]))
  		user.update_attributes(forgot_password_token: nil)
      flash[:notice] = "Your password as been updated"
      redirect_to '/login'
  	else
  		redirect_to :root
  	end
  end

  def logout
  	session[:email] = nil
	redirect_to :root
  end

 
end
