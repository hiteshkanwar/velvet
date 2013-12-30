class AddAvatarTmpToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :avatar_tmp, :string
  end
end
