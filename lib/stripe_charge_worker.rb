class StripeChargeWorker
  def perform
     advertisers = Advertiser.where("ad_served > ?",0)
     advertisers.each {|x|x.delay.charge_payment }
  end
end
