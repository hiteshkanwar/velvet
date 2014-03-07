class CreateUserBlocks < ActiveRecord::Migration
  def change
    create_table :user_blocks do |t|
      t.integer :blocked_id
      t.references :user

      t.timestamps
    end
    add_index :user_blocks, :user_id
  end
end
