class Advertiser < ActiveRecord::Base
  attr_accessible :company, :email, :first_name, :industry, :job_function, :job_title, :last_name, :phone
  attr_accessible :tippin_user_name, :total_budget, :website, :campaign_name,:max_cpm,:is_active,:campaign_image
  attr_accessible :plan_id,:stripe_card_token_field
  mount_uploader :campaign_image, CampaignUploader

  attr_accessor :stripe_card_token_field
  validates_presence_of :company, :email, :first_name, :industry, :job_function, :job_title, :last_name
  validates_presence_of :max_cpm, :phone, :tippin_user_name, :total_budget, :website,:campaign_image,:campaign_name

  scope :by_uuid,lambda{|uuid|where("uuid = ?",uuid) }
  scope :active,lambda{where("active = ?",true) }
  scope :approved,lambda{where("approved = ?",true) }
  scope :except_ids,lambda{|ids| where("id not in = ()?",ids) if ids.present?}
  

  def save_with_stripe
    
    if valid?
      Stripe.api_key = ENV['STRIPE_API_KEY']

      begin
        customer = Stripe::Customer.create(
          :description => "Customer for #{self.email} and for campaign #{self.campaign_name}",
          :card => self.stripe_card_token_field)
        self.stripe_customer_token =  customer.id
        self.uuid = SecureRandom.uuid
        self.remaining_budget = self.total_budget

        self.save!

      rescue Exception => e  
        false
      end  
    else
      false
    end    

  end

  def full_name
    [self.first_name ,self.last_name].join(" ")
  end

  def send_admin_notification
    UserMailer.campaign_notification(self).deliver
  end

  def approve_ad
    self.approved = true
    self.active  = true
    self.save!  
  end

  def stop_ad
    self.approved = false
    self.save!  
  end
  def activate
    self.active = true
    self.save!
  end

  def de_activate
    self.active = false
    self.save!
  end

  def self.get_ad(except_ids=[])
    # Get advertisement where remaining budget is greater than 0 and order by max cpm
    advertiser = Advertiser.approved.active.where("remaining_budget > ?",0).order("max_cpm desc").except_ids(except_ids).limit(1).first

  end

  def ad_is_served
    self.total_ad_served = self.total_ad_served.to_f + 1
    # LAST 24 hour add to calculate
    self.ad_served = self.ad_served.to_f + 1
    self.save!
    update_remaining_budget
    
  end
  
  def update_remaining_budget
    if self.remaining_budget > 0
      self.remaining_budget =  self.total_budget - (self.max_cpm.to_f/(1000.0/self.total_ad_served)).round(2)
      self.save!
      self.stop_ad if self.remaining_budget < 0
    else  
      self.stop_ad
    end
      
  end
  
  def get_charge_amount
    (self.max_cpm.to_f/(1000/self.ad_served.to_f)).round(2)
  end

  def get_charge_amount_in_cents
    (get_charge_amount*100.0).to_i
  end

  def charge_payment
    begin
      Stripe.api_key = ENV['STRIPE_API_KEY']
      amount= get_charge_amount_in_cents
      # Amount atleast greater than 100 cents then do transaction
      if amount >= 100
        charge = Stripe::Charge.create(
            :amount => amount,
            :currency => "usd",
            :customer => stripe_customer_token,
            :description => "Charge for campaign #{campaign_name} for #{email} for customer id #{stripe_customer_token}"
          )
        self.ad_served = 0
        self.save!
      end   

    rescue Exception => e  
      stop_ad
      UserMailer.payment_failed(self)
    end  
  end

end
