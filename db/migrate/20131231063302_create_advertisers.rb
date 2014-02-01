class CreateAdvertisers < ActiveRecord::Migration
  def change
    create_table :advertisers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :tippin_user_name
      t.string :company
      t.string :phone
      t.string :website
      t.string :industry
      t.string :job_title
      t.string :job_function
      t.string :plan_id
      t.string :campaign_image
      t.string :campaign_name
      t.string :stripe_customer_token
      t.string :uuid
      t.integer :user_id
      t.float :max_cpm
      t.float :total_budget
      t.float :ad_served,:default=>0.0
      t.boolean :active,:default=>false
      t.timestamps
    end

    add_column :advertisers, :ga_account, :string
    add_column :advertisers, :ga_website, :string
  end
end
