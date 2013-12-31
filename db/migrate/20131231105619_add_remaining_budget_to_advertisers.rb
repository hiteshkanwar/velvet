class AddRemainingBudgetToAdvertisers < ActiveRecord::Migration
  def change
    add_column :advertisers, :remaining_budget, :float,:default=>0
    add_column :advertisers, :total_ad_served, :float,:default=>0
    add_column :advertisers, :approved,:boolean,:default=>false
  end
end
