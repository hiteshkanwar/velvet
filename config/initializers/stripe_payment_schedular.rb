require 'pry'
require 'rufus-scheduler'
scheduler = Rufus::Scheduler.start_new

scheduler.cron '5 0 * * *' do
  # do something every day, five minutes after midnight
  # (see "man 5 crontab" in your terminal)
  StripeChargeWorker.new.perform
end

