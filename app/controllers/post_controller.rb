class PostController < ApplicationController
include ApplicationHelper
include EmojiHelper
	# ---------------
 	# Validations
	# -------------
	before_filter :confirm_logged_in
	before_filter :current_user, :except => [:index]
	

	def create
     @user = @current_user
	 
    if params["file-0"] || params[:body]
			begin
				@tip_create=@current_user.posts.new
				@tip_create.avatar= params["file-0"]
				@tip_create.body= params[:body]
				@tip_create.save
				# flash[:notice] = "Posted " + "#{params[:post][:body][0..17]}..."
			rescue => error
				flash[:notice] = error.full_messages.to_sentence
			end
		else
			flash[:notice] = "Write something..."
		end
	   @user.assigned_posts = @current_user.followings_posts(params[:page]).uniq
	  #@user.assigned_posts = current_user.posts
	  respond_to do |format|
        format.js # actually means: if the client ask for js -> return file.js
      end
	end

	def admire
		post = Post.find(params[:post_id])
		@post = Post.find(params[:post_id])
		if @post
			@current_user.admires.create(post_id: @post.id)
			if !@post.user.nil? && !@post.user.blank?
			  @post.user.activities.create(person: @current_user.id, description: "Admired your tip",post_id: post.id)
			  flash[:notice] = "Admired"
			 end
		end
		respond_to do |format|
			format.js	
		end
		
	end

	def unadmire
		
		post = Post.find(params[:post_id])
		@post = Post.find(params[:post_id])
		if post && admire = @current_user.admires.find_by_post_id(post.id)
			@current_user.admires.delete(admire)
			flash[:notice] = "Unadmired post"
		end
		respond_to do |format|
			format.js	
		end
		# redirect_to request.referer
	end


	def repost

		post = Post.find(params[:id])
		if post
			begin
				post.repost_count = post.repost_count + 1
				post.save
				@current_user.reposts.create(post: post)
				post.user.activities.create(person: @current_user.id, description: "Retiped your tip", post_id: post.id)
				
				flash[:notice] = "Post as been retipped to your profile"
			rescue => error
			end
		end
		@post=post
		respond_to do |format|
				format.js	
		end
		#redirect_to "/#{@current_user.username}"
		#redirect_to request.referer
	end
	def retweeted
		@repost=Repost.find_by_post_id_and_user_id(params[:id],@current_user.id)
       if !@repost.nil?
       	@repost.delete
       	flash[:notice] = "Remove retweet sucessfully...."
       end
       
       @post=Post.find(params[:id])
      @post.repost_count = @post.repost_count - 1
      @post.save
		respond_to do |format|
				format.js	
		end
	end

	def comment
		
		post = Post.find(params[:id])
		if post && params[:body]
			
			@comment=post.comments.new
			@comment.user_id= @current_user.id
			@comment.body=params[:body]
			@comment.avatar=params["file-0"]
            @comment.save
			flash[:notice] = "Posted reply..."

		end
		@post=post
		@comments = post.comments
		
	    respond_to do |format|
        	format.js # actually means: if the client ask for js -> return file.js
        end
	end

	def remove
		comment = Comment.find(params[:id])
		# Allow comment or post owner to remove comment
		if comment && (comment.user == @current_user || comment.post.user == @current_user)
			# Find comment user and remove comment
			# comment.user.comments.find(comment).destroy
			comment.post.comments.find(comment).destroy
			flash[:notice] = "Comment as been removed..."
		end
		redirect_to request.referer
	end

	def destroy
		if @current_user.posts.find(params[:id])
			begin
				@current_user.posts.find(params[:id]).destroy
				flash[:notice] = "Post as been removed..."
				@current_user.reposts.find_by_post_id(params[:id]).destroy
			rescue => error
			end
		end
		redirect_to request.referer
	end

	def funmoji_post
		
		@post_id = params[:post_id]
    	@content = params[:post_data]
        @content = @content.gsub(" :","<img width='30' src='/assets/emoji/").gsub(":",".png'/>")
	end
end