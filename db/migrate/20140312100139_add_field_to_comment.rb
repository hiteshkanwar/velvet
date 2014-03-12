class AddFieldToComment < ActiveRecord::Migration
  def change
    add_column :comments, :avatar, :string
  end
end
