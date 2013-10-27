class DashboardController < ApplicationController
	layout 'main/application'

	# ---------------
 	# Validations
	# -------------

	before_filter :confirm_logged_in
	before_filter :only => [:acquaint, :direct_message, :admire, :message, :add_to_list] do |c| c.not_found params[:id] end 
	before_filter :current_user, :only => [:show]
	
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
      	return true
      end
    end

    # ---------------------
    # @current_user : self, @user : other user
    # ---------------------

	def index
		render 'index', :layout => false
	end


	# -----------
	# Controls
	# ---------------

	def acquaint

		if !@current_user.is_following.include? @user
			@user.followers.create(follower_id: @current_user.id)
			flash[:notice] = "Now following #{@user.name}"
		else
			flash[:notice] = "You're already following #{@user.name}"
		end

		redirect_to "/#{@user.username}"
	end

	def direct_message
		flash[:notice] = "Not yet implemented"
		redirect_to "/#{@user.username}"
	end

	def admire

		if Post.find(params[:post_id])
			@current_user.admires.create(post_id: params[:post_id])
			flash[:notice] = "Admired"
		end
		redirect_to "/#{@user.username}"
		
	end

	def message
		flash[:notice] = "Not yet implemented"
		redirect_to "/#{@user.username}"
	end

	def add_to_list
		flash[:notice] = "Not yet implemented"
		redirect_to "/#{@user.username}"
	end

	# ----------

end
