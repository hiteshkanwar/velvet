class MessagesController < ApplicationController
  before_filter :confirm_logged_in
  layout 'main/application'
  def index
    @messages = @current_user.messages.not_trash.order("created_at desc")
    @current_user.messages.not_trash.update_all(seen: true)
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
       User.find(params[:message][:receiver_id]).activities.create(person: @current_user.id, description: "Sent you a message")
       redirect_to sent_messages_path
    else
      @messages = @current_user.send_messages.order("created_at desc")
      render :action=>:new
    end
  end

  def sent
    @messages = @current_user.send_messages.order("created_at desc")
  end

  def trash
    @messages = @current_user.messages.trash_messages.order("created_at desc")
  end

  def move_to_trash
    @message = current_user.messages.find(params[:id])
    @message.move_to_trash
    redirect_to :back
  end

  def destroy
    if params[:trash]
      @message = current_user.messages.find(params[:id])
    else
      @message = current_user.send_messages.find(params[:id])
    end
    
    @message.destroy
    redirect_to :back
  end

  def search_receivers
    @users = User.where("username like ? OR name like ?", "%#{params[:q]}%", "%#{params[:q]}%")
    autocomplete = @users.map { | user | 
        { label: "#{user.name} @#{user.username}", value: "#{user.name} @#{user.username}",:id=>user.id ,:user_avatar=>user.user_avatar}
      }

     render :json => autocomplete 
  end

  def undelete
    @message = current_user.messages.find(params[:id])
    @message.undelete
    redirect_to trash_messages_path()
  end
end