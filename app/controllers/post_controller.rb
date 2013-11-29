class PostController < ApplicationController
	
	# ---------------
 	# Validations
	# -------------
	before_filter :confirm_logged_in
	before_filter :current_user, :except => [:index]
	
	def current_user
	    @current_user ||= User.find_by_email(session[:email])
	end
	
	def create

		if params[:body]
			@current_user.posts.create(body: params[:body])
			flash[:notice] = "Posted " + "#{params[:body][0..17]}..."
		else
			flash[:notice] = "Write something..."
		end
		redirect_to request.referer
	end

	def admire
	end


	def repost
		post = Post.find(params[:id])
		@current_user.reposts.create(post: post) if post
		redirect_to "/#{@current_user.username}"
	end

	def comment
		post = Post.find(params[:id])
		if post && params[:body]
			post.comments.create(body: params[:body], user: @current_user)
			flash[:notice] = "Posted reply..."
		end
		redirect_to request.referer
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

end
