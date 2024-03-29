class ProfileController < ApplicationController
	layout 'main/application'
	include ApplicationHelper
	# ---------------
 	# Validations
	# -------------
    before_filter :confirm_logged_in
	before_filter :expect => [:nil] do |c| c.not_found params[:username] end 
	before_filter :current_user, :except => [:index]
	before_filter :only => [:edit, :create_list, :add_members, :change_avatar, :change_header] do |c| c.editable params[:username] end 
	before_filter :serve_ad,:only=>[:show,:acquainting,:acquaintances,:admired,:lists,:emoji,:edit,:ads]
	def current_user
		unless session[:email]
			# Default user if not signed in.
			@current_user = User.new
		else
	    	@current_user ||= User.find_by_email(session[:email])
	    end
	end

	def editable(username)
		raise ActionController::RoutingError.new('Not Found') unless @current_user == @user
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
	def private_active
		if @current_user.private
			@current_user.update_attributes(:private=>0)
		else
			@current_user.update_attributes(:private=>1)
		end
		respond_to do |format|
			 format.js
		end
	end

	def index
		redirect_to :root
	end

	def show
		
      @all_messages = []
       sender_messages=[]
       sender_message =current_user.messages
        if !sender_message.blank?
          sender_message.each do |sender|
            
            if sender.sender_id == @user.id

              sender_messages << sender
            end
          end
        end
       
       receiver_messages=[]
       receiver_message = @user.messages
        if !receiver_message.blank?
          receiver_message.each do |receive|
           if receive.sender_id== current_user.id
            receiver_messages << receive
           end
          end
        end
        
       @all_messages << sender_messages
       @all_messages << receiver_messages

       @all_messages =  @all_messages.flatten.sort_by(&:created_at)
       logger.debug session[:username]
	   @current_url = request.original_url

	end


	def show_more_posts
	end

	# Display user tips
	def tips
		redirect_to action: 'show', username: params[:username]
	end

	# People user is following
	def acquainting
		@users_to_display = @user.is_following.uniq
	end

	# People following user
	def acquaintances
		@users_to_display = @user.is_followers.uniq
	end

	def edit
		

		["notification", "account", "profile", "password"].include? params[:id] ? 
				@partial = params[:id] : @partial = "profile"

		
	end

	# Update user profile
	def update
	
			
		if	!@current_user.update_attributes(params[:user])
			flash[:notice] = @current_user.errors.full_messages.to_sentence
			redirect_to request.referrer
		else
			session[:email] = @current_user.email
			session[:username] = @current_user.username
			flash[:notice] = "Setting's updated"
			redirect_to "/#{@current_user.username}/edit"
		end

	end

	def destroy_background
		@current_user.remove_background!
		@current_user.save
		redirect_to "/#{@current_user.username}/edit"
	end

	def change_avatar
		@current_user.avatar.key = params[:key]
		@current_user.save
		redirect_to request.referrer
	end

	def change_header
		@current_user.header.key = params[:key]
		@current_user.save
		redirect_to request.referrer
	end

	# Create new lists
	def create_list
		@current_user.lists.create(params[:list])
		redirect_to "/#{@current_user.username}/lists"
	end

	# Add members to list

	def add_members
		begin
			list = List.find(params[:list_id])
			
			# Only, owner can add anybody to list, else you can only add yourself.
			if params[:user_id].to_i == @current_user.id || list.user == @current_user
				
				# If list is public, anybody can join else only owner can add new users to private lists
				if list.is_public || list.user == @current_user
					
					@members = list.members.map { |member| member.user }.flatten
					if !@members.include? User.find(params[:user_id])
						list.members.create(user_id: params[:user_id])
						flash[:notice] = "Added!"
					else 
						logger.debug "User already added"
					end
				end
			end 
		rescue => error
			flash[:notice] = "Error!"
		end
		redirect_to request.referrer
	end


=begin
	def add_members
		begin
			@members = @current_user.lists.find(params[:list_id]).members.map { |member| member.user }.flatten
			if !@members.include? User.find(params[:user_id])
				@current_user.lists.find(params[:list_id]).members.create(user_id: params[:user_id])
				flash[:notice] = "Added!"
			end
		rescue => error
			flash[:notice] = "Error!"
		end
		redirect_to request.referrer
	end
=end

	# Destroy list
	def destroy_list
		@current_user.lists.find(params[:id]).destroy rescue nil
		redirect_to request.referrer
	end

	def update_password
		if @current_user.hashed_password == Digest::SHA1.hexdigest(params[:current_password])
			@current_user.update_attributes(hashed_password: Digest::SHA1.hexdigest(params[:change_password]))
		
			flash[:notice] = "Password saved"
		else
			flash[:notice] = "Incorrect password"
		end

		redirect_to request.referrer
	end

	# Display emoji sheet
	def emoji
		
	end

	# People user admires
	def admired
		#flash[:notice] = "Not yet implemented"
		#redirect_to "/#{@user.username}" 
		@posts = @user.admires.map { |admire| 
			begin
			Post.find(admire.post_id) 
			rescue => error
			end
		}.uniq.compact
		@user.assigned_posts = @posts.sort{|a, b| b[:created_at] <=> a[:created_at]}
	end

	# User lists
	def lists
		
		@followed = @current_user.followers.find(:all, :order => "created_at desc", :limit => 5, :conditions => "followings.follower_id IS NOT NULL").map{ |follower| User.find(follower.follower_id)}.uniq

		if params[:id] && params[:id] == 'create'
			render 'list_create'
		elsif params[:id] == 'members'
			@list = List.find(params[:list_id]) rescue nil
			@users_to_display = @list.members.map { |member| member.user }.flatten if @list
			render 'list_members' if @list
		end
	end

	# create before filter to validate 
	#  session[:username] is current viewing username

	def message
		@messages = @current_user.messages
	end

	def settings
	end
	
	def ads
		@advertisers = @current_user.advertisers
	end

end
