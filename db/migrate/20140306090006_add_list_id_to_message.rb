class AddListIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :list_id, :integer
  end
end
