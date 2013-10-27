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

	def create_repost
		@current_user.reposts.create(post_id: params[:id]) if Post.find(params[:id])
	end

	def reply
	end

	def comment
		post = Post.find(params[:id])
		if post
			post.comments.create(body: params[:body], user: @current_user)
			flash[:notice] = "Write something..."
		end
		redirect_to request.referer
	end

	def destroy
		@current_user.posts.find(params[:id]).destroy
		redirect_to request.referer
	end

end
