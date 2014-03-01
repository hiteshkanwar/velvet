require 'pry'
class MessagesController < ApplicationController
  before_filter :confirm_logged_in
  before_filter :serve_ads,:only=>[:index,:new,:sent,:trash,:lists,:emoji]
  layout 'main/application'

  def index
    @messages = @current_user.all_messages.not_trash.roots.order("created_at desc")
    @current_user.messages.not_trash.update_all(seen: true)
  end
  def show_conversation
    @message = @current_user.all_messages.not_trash.find(params[:id])

  end
  
  def new
    @message = @current_user.send_messages.new
    @attachment = @message.attachments.new
    @parent_message = @current_user.all_messages.find(params[:parent_id])  rescue nil
    @receiver = User.find(params[:receiver_id]) rescue nil if params[:receiver_id].present?
    
    @users = User.all
  end

  def create

    @message = @current_user.send_messages.new(params[:message])
      
    if @message.save
      # redirect_to "/"+params[:username]+"/messages/new"
       User.find(params[:message][:receiver_id]).activities.create(person: @current_user.id, description: "Sent you a message")
       # redirect_to messages_path

       @all_messages = []
       sender_message =current_user.messages
       
       @user=User.find(params[:message][:receiver_id].to_i)
       receiver_messages = @user.messages
       @all_messages << sender_message
       @all_messages << receiver_messages
       @all_messages =  @all_messages.flatten.sort_by(&:created_at)
      respond_to do |format|
        format.js # actually means: if the client ask for js -> return file.js
      end
    else
      @messages = @current_user.send_messages.order("created_at desc")
      @attachment = @message.attachments.new
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
    redirect_to messages_path
  end

  def destroy
    # if params[:trash]
    #   @message = current_user.messages.find(params[:id])
    # else
    #   @message = current_user.send_messages.find(params[:id])
    # end
    @message = @current_user.all_messages.find(params[:id])
    @message.destroy
    redirect_to messages_path
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

  def message_count_update
  end

   def account_delete_user
    @user = User.find(current_user.id)
    session[:email] = nil
    session[:username] = nil
    @current_user = nil
    @user.destroy
    redirect_to :root
  end
  
end