class AddFieldToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :post_id, :integer
  end
end
