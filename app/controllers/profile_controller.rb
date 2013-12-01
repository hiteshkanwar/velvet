class ProfileController < ApplicationController
	layout 'main/application'
	# ---------------
 	# Validations
	# -------------

	before_filter :expect => [:nil] do |c| c.not_found params[:username] end 
	before_filter :current_user, :except => [:index]
	
	def current_user
		unless session[:email]
			# Default user if not signed in.
			@current_user = User.new
		else
	    	@current_user ||= User.find_by_email(session[:email])
	    end
	end

	def not_found(username)
	  @user = User.where(username: username)
	  if @user.empty?
      	raise ActionController::RoutingError.new('Not Found')
      else
      	@user = @user.first
      	@title = "#{@user.name} - Profile"
      	return true
      end
    end


    # ---------------------
    # @current_user : self, @user : other user
    # ---------------------


	def index
		redirect_to :root
	end

	def show
		logger.debug session[:username]
		@current_url = request.original_url

	end


	def show_more_posts
	end


	def tips
		redirect_to action: 'show', username: params[:username]
	end

	# People user is following
	def acquainting
		@users_to_display = @user.is_following
	end

	# People following user
	def acquaintances
		@users_to_display = @user.is_followers
	end

	# Display emoji sheet
	def emoji
	end

	# People user admires
	def admire
		flash[:notice] = "Not yet implemented"
		redirect_to "/#{@user.username}"
	end

	# User lists
	def lists
		flash[:notice] = "Not yet implemented"
		redirect_to "/#{@user.username}"
	end

	# create before filter to validate 
	#  session[:username] is current viewing username

	def message
	end

	def settings
	end

end
