class DashboardController < ApplicationController
	layout 'main/application'
	include ApplicationHelper
	# ---------------
 	# Validations
	# -------------

	before_filter :confirm_logged_in
	before_filter :only => [:acquaint, :unacquaint, :direct_message, :admire, :message, :add_to_list] do |c| 
		c.not_found params[:id]
	end 
	before_filter :serve_ads,:only=>[:activity,:index,:discover]
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

    def invitation	
		
		@invite=SubscribeAndInvitation.create(:list_id=>params[:list_id],:user_id=>params[:user_id],:subscribe=>0)
		@followed = @current_user.followers.find(:all, :order => "created_at desc", :limit => 5, :conditions => "followings.follower_id IS NOT NULL").map{ |follower| User.find(follower.follower_id)}.uniq
		@list=List.find(params[:list_id])


		Message.create(:message_text=>"User (#{@current_user.name}) has invited you to join their list #{@list.name}", :sender_id=>@current_user.id,:receiver_id=>params[:user_id],:list_id=>@list.id)
		respond_to do |format|
			 format.js
		end
	end
	def subscribe
		@invite=SubscribeAndInvitation.find_by_user_id_and_list_id(params[:user_id],params[:list_id])
		if @invite.nil?
			@invite=SubscribeAndInvitation.create(:list_id=>params[:list_id],:user_id=>params[:user_id],:subscribe=>1)
		else
			@invite.update_attributes(:list_id=>params[:list_id],:user_id=>params[:user_id],:subscribe=>1)
		end	
		@list=List.find(params[:list_id])
		@user=User.find(params[:user_id])
		respond_to do |format|
			 format.js
		end
	end
	def unsubscribe
				
		@list=List.find(params[:list_id])
		@user=User.find(params[:user_id])
		if @list.subscribe_and_invitations.present?
			SubscribeAndInvitation.find_by_user_id_and_list_id(@user.id,@list.id).destroy
			@destroy=true
		end
		
		respond_to do |format|
			 format.js
		end

	end	



	def index

		#puts request.fullpath
		@posts = @current_user.followings_posts
		@user = @current_user
		@user.assigned_posts = @posts.uniq
		logger.debug @user.all_posts(1)

		# --- total pages for all posts

		@total_pages = 0
		@user.assigned_posts.each do |post|
			@total_pages += post.user.posts.paginate(page: params[:page], per_page: 2).total_pages
		end

		logger.debug("pages: #{@total_pages}")

		# ---
		
		@posts - @current_user.posts.order('created_at desc').limit(10)  # when queried for notification, don't include user posts
	end

	def paginate
		
		case params[:source]
		when 'home'
			@user = @current_user
			@user.assigned_posts = @current_user.followings_posts(params[:page]).uniq
		else
			nil
		end

		render 'paginate', layout: false
	end

	# Find users & post with similar keywords.

	def search
		
		@user =  @current_user # Map current user to user in profile/_user
		if params[:retips]
			post = Post.find(params[:retips])
			@users_to_display = post.reposts.map { |repost| repost.user }.flatten.uniq
		else

			
			@users = User.where("lower(username) like ? OR lower(name) like ?", "%#{params[:q]}%", "%#{params[:q]}%")||User.where("username like ? OR name like ?", "%#{params[:q]}%", "%#{params[:q]}%")
			@posts = Post.where("body like ?", "%#{params[:q]}%").map { |p| p.user }	
			@users_before_display = (@users + @posts).flatten.uniq
			@users_to_display=[]
			@users_before_display.each do |user|
				if private_search(user)
				@users_to_display<<user
				end
			end
		

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
	end

	def discover
		@posts=[]
		@all_posts = Post.find(:all, :order => "created_at desc")
		
		followers=Followings.where(:follower_id=>@current_user.id).collect(&:user_id)
		@all_posts.each do |post|
			if post.user_id==current_user.id || !(User.find(post.user_id).private) || followers.include?(post.user_id)
				@posts<<post
			end	
		end	
		@user = User.new
		@user.assigned_posts = @posts
        @total_pages = 0
		@user.assigned_posts.each do |post|
			@total_pages += post.user.posts.paginate(page: params[:page], per_page: 2).total_pages
		end

		logger.debug("pages: #{@total_pages}")
		 #logger.debug @user.all_posts(1)
	end

	def activity
        
		 puts request.fullpath
		# 1. People who mentioned me
		@mentioned = Post.where("body like ?", "%#{@current_user.username}%").order('updated_at desc').limit(10)

		# 2. People who admired my tips
		# Todo -
		@activities=[]
		@activitie2 = @current_user.activities.sort{|a, b| b[:created_at] <=> a[:created_at]}
        @activities1=Activity.find(:all,:conditions=>['person = ?',@current_user.id])
		@activities << @activitie2
		@activities << @activities1
		@activities=@activities.flatten

		# 3. People who followed me
		  @followed = []
		 @followed = @current_user.followers.find(:all, :order => "created_at desc", :limit => 5, :conditions => "followings.follower_id IS NOT NULL").map{ |follower| User.find(follower.follower_id)}

		@posts = @mentioned
		@user = @current_user
		@user.assigned_posts = @posts

		@posts
		@total_pages = 0
		@user.assigned_posts.each do |post|
			@total_pages += post.user.posts.paginate(page: params[:page], per_page: 2).total_pages
		end

		logger.debug("pages: #{@total_pages}")

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

    def block_user
    	
    	BlockUser.create(:blocked_id=> params[:id], :user_id=> @current_user.id)
    	redirect_to request.referrer
    end
    def unblock_user
    	
    	@user=@user=BlockUser.find(:all,:conditions=>['user_id=? AND blocked_id= ?' ,@current_user.id,params[:id].to_i])
    	@user.first.delete
    	redirect_to request.referrer
    	
    end
	# ----------
    def show_post
    	if params[:id]
		@post=Post.find(params[:id])
	    else
	    redirect_to request.referrer
	    end
	end

end
