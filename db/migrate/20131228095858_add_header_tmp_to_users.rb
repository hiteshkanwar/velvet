class AddHeaderTmpToUsers < ActiveRecord::Migration
  def change
    add_column :users, :header_tmp, :string
  end
end
