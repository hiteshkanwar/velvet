class AddIsPublicToLists < ActiveRecord::Migration
  def change
    add_column :lists, :is_public, :boolean, default: true
  end
end
