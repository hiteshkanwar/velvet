class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.integer :user_id
      t.integer :follower_id
      t.boolean :blocked

      t.timestamps
    end
  end
end
