class LandingController < ApplicationController
	
	layout 'application'
  
  # Views --------------
  def index

  	render 'index', layout: false
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

  def dmca
    render 'dmca', layout: false 
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
  	render 'about', layout: false 
  end

  def terms
    render 'terms', layout: false 
  end

  def privacy
    render 'privacy', layout: false 
  end

  # Controls -----------------
  
  def validate_login
   user = User.find_by_email(params[:email])
   
    # if user.block!=true
      if user && user.validated.present?
        if user.block!=true
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
        else
          flash[:notice] = "You are blocked by admin Please try after some time...."
          redirect_to :root
        end  
      else
        if user
          flash[:notice] = "Please verify your email"
        
          session[:validate_email] = "validate_email_false"
          session[:resend] = params[:email]
          redirect_to :root
        else  
          flash[:notice] = "Your login details are wrong"
          redirect_to :root
        end
       
      end
    
  end

  def resend

    user = User.find_by_email(params[:email])
    if user && user.validated.nil?
      
      user.update_attributes(code: generate_activation_code(12))
      flash[:notice] = "Activation link as been sent to #{user.email}"
      UserMailer.welcome_email(user).deliver
    end

    redirect_to :root
  end

  def create
   
    if simple_captcha_valid?
    	@user = User.new(name: params[:name], username: params[:username], email: params[:email].downcase, hashed_password: params[:password], country: params[:country], dob: "#{params[:month]}/#{params[:day]}/#{params[:year]}")
      @current_time=Time.now.strftime("%Y")
      if (@current_time > params[:year])
        @time= Time.now.strftime("%Y").to_i-params[:year].to_i
        if (@time>=18)
        	if @user.save

        	 	logger.debug("User created successfuly")
        	 	#session[:email] = @user.email
            #session[:username] = @user.username

            flash[:notice] = "Please verify your account, by click on the activitation link sent to your email address"

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
        else
          flash[:notice] = "This site is only for use by persons over 18 years of age"
          redirect_to :root
        end 
      else
        flash[:notice] = "Enter Valid Age"
        redirect_to :root
      end   
    else 
      session[:flag]= simple_captcha_valid?
      flash[:notice] = "Invalid captcha, please try again"
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
       #redirect_to '/forgot'
       redirect_to :root
  	else
  		flash[:notice] = "This email address is not registered"
      #redirect_to '/forgot'
  		redirect_to :root
  	end

  end

  def verify

    #=> Give user and referral incentives
    begin
      user = User.find(params[:id])
      user.update_attributes(validated: true) if user.validated.nil? && params[:code] == user.code
      flash[:notice] = "Thank you for verifying your account"
    rescue => error
      logger.debug(error.to_s)
      flash[:notice] = "Invalid verification code"
    end

     redirect_to :root

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
    @current_user = nil
	  redirect_to :root
  end

 
end
