class ChangeDataTypeForFieldname < ActiveRecord::Migration
  def up

    rename_column :emojis, :transaction, :transaction_id
  
  end

  def down
  end
end
