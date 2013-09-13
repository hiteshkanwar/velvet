class DashboardController < ApplicationController
	
	before_filter :confirm_logged_in

	def index
		render 'index', :layout => false
	end
end
