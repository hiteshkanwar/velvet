class AddGaScriptToAdvertisers < ActiveRecord::Migration
  def change
    add_column :advertisers, :ga_script, :text
  end
end
