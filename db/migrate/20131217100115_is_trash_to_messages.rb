class IsTrashToMessages < ActiveRecord::Migration
  def up
     add_column :messages, :is_trash, :boolean,:default=>false
  end

  def down
    remove_column :messages, :is_trash
  end
end
