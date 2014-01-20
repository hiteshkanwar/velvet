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
		@user = @current_user
		@user.assigned_posts = @posts.uniq
		logger.debug @user.all_posts(1)
		serve_ad
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
		serve_ad
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
		  @followed = []
		# @followed = @current_user.followers.find(:all, :order => "created_at desc", :limit => 5, :conditions => "followings.follower_id IS NOT NULL").map{ |follower| User.find(follower.follower_id)}

		@posts = @mentioned
		@user = @current_user
		@user.assigned_posts = @posts
		serve_ad
		@posts
	end

	def notification
		status = [0, 0]

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
		
		if feed && (Time.now - feed.created_at) <= 59 # Less than a minute ago
			status[0] = 1
			params[:seed] == '/' ? status[1] = 1 : nil
			logger.debug("New posts available")
		end

		# Fetch new posts
		if params[:fetch]

			# Get all posts
			@posts = @current_user.followings_posts
			@user = @current_user
			@user.assigned_posts = @posts.uniq

			logger.debug("Loading dashboard posts")

			render 'notification', layout: false

		# Or check if new posts available
		else
			respond_to do |format|
			    format.json {render :json => status }
			end
		end
			
	end

	def emoji_modal
		render 'emoji_modal', layout: false
	end


	# -----------
	# Controls
	# ---------------



	# Purchase emoji
	def purchase
		
	    # Stripe acess token to bill user
	
	    price = params[:family] == "all" ? 4.99 : 1.99 
	    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

	    # Get the credit card details submitted by the form
	    card_token = params[:stripeToken]

	    # Create the charge on Stripe's servers - this will charge the user's card
	    begin

	      charge = Stripe::Charge.create({
	        :amount => (price * 100).to_i, # amount in cents, again
	        :currency => 'USD',
	        :card => card_token,
	        :description => "Paying for Emoji",
	      })

	      flash[:notice] = "Your payment was successful. Enjoy!"

	      # Save transaction
	      @current_user.emojis.create(name: params[:family], transaction_id: charge.id, provider: 'Stripe')
	     
	    rescue Stripe::CardError => e
	      # The card has been declined or some error
	      flash[:notice] = e.to_s
	    end

	    redirect_to "/#{@current_user.username}/emoji"
	end

	def acquaint

		if !@current_user.is_following.include? @user && @current_user != @user
			@user.followers.create(follower_id: @current_user.id)
		    @user.activities.create(person: @current_user.id, description: "Acquainted You")
			flash[:notice] = "Now acquainting #{@user.name}"
		else
			flash[:notice] = "You're already acquainting #{@user.name}"
		end

		redirect_to request.referrer
	end

	def unacquaint
		
		begin
			following = @current_user.following.find_by_user_id(@user.id)
			Followings.find(following.id).destroy if following

			#@current_user.following.destroy(@current_user.following.find_by_user_id(@user.id))
			#@user.followers.de(@user.followers.find_by_follower_id(@current_user.id)
			flash[:notice] = "You have unacquainted #{@user.name}"
		rescue => error
			flash[:notice] = "Error"
		end
		
		redirect_to request.referrer
	end


	# ----------

end
