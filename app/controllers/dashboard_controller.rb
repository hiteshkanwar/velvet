class DashboardController < ApplicationController
	layout 'main/application'

	# ---------------
 	# Validations
	# -------------

	before_filter :confirm_logged_in
	before_filter :only => [:acquaint, :unacquaint, :direct_message, :admire, :message, :add_to_list] do |c| 
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

		#puts request.fullpath
		@posts = @current_user.followings_posts
		@user = User.new
		@user.assigned_posts = @posts

		logger.debug @user.all_posts(1)

		@posts - @current_user.posts.order('created_at desc').limit(10)  # when queried for notification, don't include user posts
	end

	# Find users & post with similar keywords.

	def search

		@user =  @current_user # Map current user to user in profile/_user
		@users = User.where("username like ? OR name like ?", "%#{params[:q]}%", "%#{params[:q]}%")
		@posts = Post.where("body like ?", "%#{params[:q]}%").map { |p| p.user }	
		@users_to_display = (@users + @posts).flatten.uniq
	

		if params[:source] && params[:source] == "autocomplete"
			autocomplete = @users_to_display.map { | user | 
				{ label: "#{user.name} @#{user.username}", value: user.username,:id=>user.id }
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

		@posts
	end

	def activity

		 puts request.fullpath
		# 1. People who mentioned me
		@mentioned = Post.where("body like ?", "%#{@current_user.username}%").order('created_at desc').limit(10)

		# 2. People who admired my tips
		# Todo -
		@activities = @current_user.activities.sort{|a, b| b[:created_at] <=> a[:created_at]}

		# 3. People who followed me
		@followed = @current_user.followers.find(:all, :order => "created_at desc", :limit => 5, :conditions => "followings.follower_id IS NOT NULL").map{ |follower| User.find(follower.follower_id)}

		@posts = @mentioned
		@user = User.new
		@user.assigned_posts = @posts

		@posts
	end

	def notification
		status = 0

		case params[:seed]
		when "/"
			feed = index.first
		when "/activity"
			feed = activity.first
		when "/discover"
			feed = discover.first
		else
			feed = nil
		end
		
		if feed
			status = 1 if Time.now - feed.created_at <= 59 # Less than a minute ago
		end

		respond_to do |format|
		    format.json {render :json => status }
		end
			
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

	def unacquaint
		
		begin
			following = @current_user.following.find_by_user_id(@user.id)
			Followings.find(following.id).destroy if following

			#@current_user.following.destroy(@current_user.following.find_by_user_id(@user.id))
			#@user.followers.de(@user.followers.find_by_follower_id(@current_user.id)
			flash[:notice] = "You have unaquainted #{@user.name}"
		rescue => error
			flash[:notice] = "Error"
		end
		
		redirect_to request.referrer
	end

	def direct_message
		flash[:notice] = "Not yet implemented"
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
