class CommentController < ApplicationController
	before_filter :confirm_logged_in
	
	# Create comment for post
	def create
	 	@current_user.comments.create(body: params[:body], post_id: params[:post_id])
	end
end
