class AddFieldToMedia < ActiveRecord::Migration
  def change
    add_column :media, :comment_id, :integer
  end
end
