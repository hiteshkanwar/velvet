class AddPrivateFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :private, :boolean
  end
end
