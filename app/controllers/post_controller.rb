class PostController < ApplicationController
	before_filter :confirm_logged_in
	
	def create
		@current_user.posts.create(body: params[:body])
	end

	def create_repost
		@current_user.reposts.create(post_id: params[:id])
	end

	def reply
	end

	def destroy
	end

end
