class AddAvatarTmpToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_tmp, :string
  end
end
