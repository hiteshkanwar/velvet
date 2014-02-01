class AddGaAccountNameAndGaWebsiteToAdvertisers < ActiveRecord::Migration
  def change
    remove_column :advertisers, :ga_script
  end
end
