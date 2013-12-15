class MessagesController < ApplicationController
  before_filter :confirm_logged_in
  layout 'main/application'
  def index
    @messages = @current_user.messages
  end
  
  def new
    @user =  User.where(:username=>params[:username]).first
    @messages = @current_user.send_messages.where(:receiver_id=>@user.id)
    @message = @current_user.send_messages.new
  end

  def create
    @message = @current_user.send_messages.new(params[:message])
    @user =  User.where(:username=>params[:username]).first
    @message.receiver_id = @user.id
    if @message.save
      # redirect_to "/"+params[:username]+"/messages/new"
       redirect_to "/"+params[:username]
    else
      @messages = @current_user.send_messages.where(:receiver_id=>@user.id)
      render :action=>:new
    end
  end
end