class AddRepostCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :repost_count, :integer, default: 0
  end
end
