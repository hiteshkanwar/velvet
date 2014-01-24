class AddGaAccountNameAndGaWebsiteToAdvertisers < ActiveRecord::Migration
  def change
    add_column :advertisers, :ga_account, :string
    add_column :advertisers, :ga_website, :string
    remove_column :advertisers, :ga_script
  end
end
