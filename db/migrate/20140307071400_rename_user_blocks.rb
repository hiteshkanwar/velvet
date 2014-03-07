class RenameUserBlocks < ActiveRecord::Migration
  def up
  	 rename_table :user_blocks, :block_users
  end

  def down
  	rename_table :block_users, :user_blocks
  end
end
