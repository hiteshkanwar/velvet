class PostController < ApplicationController
	
	# ---------------
 	# Validations
	# -------------
	before_filter :confirm_logged_in
	before_filter :current_user, :except => [:index]
	

	def create

		if params[:body]
			begin
				@current_user.posts.create(body: params[:body])
				flash[:notice] = "Posted " + "#{params[:body][0..17]}..."
			rescue => error
				flash[:notice] = error.full_messages.to_sentence
			end
		else
			flash[:notice] = "Write something..."
		end
		redirect_to request.referer
	end

	def admire
		post = Post.find(params[:id])
		if post
			@current_user.admires.create(post_id: post.id)
			post.user.activities.create(person: @current_user.id, description: "Admired your Post")
			flash[:notice] = "Admired"
		end
		redirect_to request.referer
		
	end

	def unadmire
		post = Post.find(params[:id])
		if post && admire = @current_user.admires.find_by_post_id(post.id)
			@current_user.admires.delete(admire)
			flash[:notice] = "Unadmired post"
		end
		redirect_to request.referer
	end


	def repost
		post = Post.find(params[:id])
		if post
			begin
				@current_user.reposts.create(post: post)
				post.user.activities.create(person: @current_user.id, description: "Retiped your Post")
				flash[:notice] = "Post as been retipped to your profile"
			rescue => error
			end
		end
		#redirect_to "/#{@current_user.username}"
		redirect_to request.referer
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
