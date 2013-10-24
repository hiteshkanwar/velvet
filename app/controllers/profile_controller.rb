class ProfileController < ApplicationController
	layout 'main/application'

	before_filter :expect => [:nil] do |c| c.not_found params[:username] end 

	def not_found(username)
	  if User.where(username: username).empty?
      	raise ActionController::RoutingError.new('Not Found')
      else
      	return true
      end
    end

	def index
		redirect_to :root
	end

	def show
		@user = params[:username]
	end

	def tips
		redirect_to action: 'show', username: params[:username]
	end

	# People user is following
	def acquainting
		render :nothing => true
	end

	# People following user
	def acquaintances
		render :nothing => true
	end

	# People user admires
	def admire
		render :nothing => true
	end

	# User lists
	def lists
		render :nothing => true
	end


end
