class AdvertisersController < ApplicationController
  layout 'advertiser'
  before_filter :current_user
  before_filter :confirm_logged_in
  def index
    @advertiser = Advertiser.new
    flash[:notice] = nil
    # render :layout=> 'advertiser'
  end

  def add_advertiser
    
    if @current_user
      @advertiser =@current_user.advertisers.new(params[:advertiser])
    else
      @advertiser = Advertiser.new(params[:advertiser])
    end  
    if  @advertiser.save_with_stripe
       @advertiser.send_admin_notification
      # Send Notification
      redirect_to confirm_advertiser_path
    else
    flash[:notice] = "Error! Please try again " +@advertiser.errors.full_messages.to_sentence
    render :action=>"index"  
    end
  end

  def confirm
  end

  def activate
    @advertiser = @current_user.advertisers.find(params[:id])
    @advertiser.activate
    redirect_to :back,:notice=>"Campaign is activated"
  end

  def de_activate
    @advertiser = @current_user.advertisers.find(params[:id])
    @advertiser.de_activate
    redirect_to :back,:notice=>"Campaign is de activated"
  end

  def approve_ad
    @advertiser = Advertiser.by_uuid(params[:uuid]).first
    @advertiser.approve_ad

    redirect_to root_path,:notice=>"Campaign is approved"
  end

  def stop_ad
   @advertiser = Advertiser.by_uuid(params[:uuid]).first
    @advertiser.stop_ad
    redirect_to root_path,:notice=>"Campaign is stop" 
  end

  
end
