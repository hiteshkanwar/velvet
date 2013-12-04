class DashboardController < ApplicationController
	layout 'main/application'

	# ---------------
 	# Validations
	# -------------

	before_filter :confirm_logged_in
	before_filter :only => [:acquaint, :direct_message, :admire, :message, :add_to_list] do |c| 
		c.not_found params[:id]
	end 

	#before_filter :only => [:discover, :activity] do |c| 
	#	c.not_found params[:username] 
	#end 

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
		@posts = @current_user.followings_posts
		@user = User.new
		@user.assigned_posts = @posts

		logger.debug @user.all_posts(1)
	end

	# Find users & post with similar keywords.

	def search

		@user =  @current_user # Map current user to user in profile/_user
		@users = User.where("username like ? OR name like ?", "%#{params[:q]}%", "%#{params[:q]}%")
		@posts = Post.where("body like ?", "%#{params[:q]}%").map { |p| p.user }	
		@users_to_display = (@users + @posts).flatten.uniq
	

		if params[:source] && params[:source] == "autocomplete"
			autocomplete = @users_to_display.map { | user | 
				{ label: "#{user.name} @#{user.username}", value: user.username }
			}

			logger.debug(autocomplete)

			respond_to do |format|
		      format.json {render :json => autocomplete }
		    end
			
		else

			
			@users_to_display.empty? ? flash[:notice] = "No results" : flash[:notice] = nil
			render 'search'
			
		end

	end

	def discover
		@posts = Post.find(:all, :order => "created_at desc", :limit => 50)
		@user = User.new
		@user.assigned_posts = @posts

		logger.debug @user.all_posts(1)
	end

	def activity

		# puts request.fullpath
		# 1. People who mentioned me
		@mentioned = Post.where("body like ?", "%#{@current_user.username}%").order('created_at desc').limit(10)

		# 2. People who admired my tips
		# Todo -

		# 3. People who followed me
		@followed = @current_user.followers.find(:all, :order => "created_at desc", :limit => 5).map{ |follower| User.find(follower.follower_id)}

		@posts = @mentioned
		@user = User.new
		@user.assigned_posts = @posts

		@posts
	end

	def activity_notification

		status = [0]
		feed = activity.order('created_at desc').limit(1)

		if feed
			status = [1] if Time.now - feed.created_at <= 59 # Less than a minute ago
		end

		#logger.debug activity.order('created_at desc').limit(1).to_json


		render nothing: true
	end


	# -----------
	# Controls
	# ---------------



	# Purchase emoji
	def purchase
		
	end

	def acquaint

		if !@current_user.is_following.include? @user
			@user.followers.create(follower_id: @current_user.id)
			# @user.activities.create(person: @current_user.id, body: "#{@current_user.name} acquainted you")
			flash[:notice] = "Now acquainting #{@user.name}"
		else
			flash[:notice] = "You're already acquainting #{@user.name}"
		end

		redirect_to "/#{@current_user.username}"
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
