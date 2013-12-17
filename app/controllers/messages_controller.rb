class MessagesController < ApplicationController
  before_filter :confirm_logged_in
  layout 'main/application'
  def index
    @messages = @current_user.messages.not_trash
  end
  
  def new
    @message = @current_user.send_messages.new
    @parent_message = @current_user.messages.find(params[:parent_id]) rescue nil
    
    @users = User.all
  end

  def create
    @message = @current_user.send_messages.new(params[:message])
  
    if @message.save
      # redirect_to "/"+params[:username]+"/messages/new"
       redirect_to sent_messages_path
    else
      @messages = @current_user.send_messages
      render :action=>:new
    end
  end

  def sent
    @messages = @current_user.send_messages
  end

  def trash
    
  end
  def move_to_trash
    @message = current_user.messages.find(params[:id])
    @message.move_to_trash
    redirect_to :back
  end

  def destroy
    @message = current_user.send_messages.find(params[:id])
    @message.destroy
    redirect_to :back
  end

  def search_receivers
    @users = User.where("username like ? OR name like ?", "%#{params[:q]}%", "%#{params[:q]}%")
    autocomplete = @users.map { | user | 
        { label: "#{user.name} @#{user.username}", value: "#{user.name} @#{user.username}",:id=>user.id }
      }

     render :json => autocomplete 
  end
end