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
      user = User.find_by_email(params[:email])
      session[:email]    = user.email
      session[:username] = user.username
    	
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
    	redirect_to :root
    end

  end

  def create

  	 @user = User.new(name: params[:name], username: params[:username], email: params[:email], hashed_password: params[:password], country: params[:country], dob: "#{params[:month]}/#{params[:day]}/#{params[:year]}")

  	 if @user.save

  	 	logger.debug("User created successfuly")
  	 	session[:email] = @user.email
      session[:username] = @user.username

        #=> Send welcome email
        UserMailer.welcome_email(@user).deliver

         # Store defaults 
         session[:signup_email] = nil
         session[:username] = nil
         session[:month] = nil
         session[:day] = nil
         session[:year] = nil
         session[:name] = nil
        
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
       # Store defaults 
       session[:signup_email] = params[:email]
       session[:username] = params[:username]
       session[:name] = params[:name]
       session[:month] = params[:month]
       session[:day] = params[:day]
       session[:year] = params[:year]

  	 	flash[:notice] = @user.errors.full_messages.to_sentence.gsub("Hashed", "")
  	 	logger.debug("User not created: #{flash[:notice]}")
  	 	redirect_to :root
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
      redirect_to :root
  	else
  		redirect_to :root
  	end
  end

  def logout
  	session[:email] = nil
    session[:username] = nil
	  redirect_to :root
  end

 
end
