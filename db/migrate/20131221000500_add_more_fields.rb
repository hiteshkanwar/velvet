class AddMoreFields < ActiveRecord::Migration
  def up

    add_column :users, :location, :string
    add_column :users, :website, :string
    add_column :users, :bio, :text
  	add_column :users, :noti_retips, :boolean, default: true
  	add_column :users, :noti_admire, :boolean, default: true
  	add_column :users, :noti_message, :boolean, default: true
  	add_column :users, :noti_follow, :boolean, default: true
    add_column :users, :noti_mention, :boolean, default: true

  end

  def down
  end
end
