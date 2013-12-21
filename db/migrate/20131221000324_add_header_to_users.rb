class AddHeaderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :header, :string
  end
end
