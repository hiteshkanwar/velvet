class CreateEmojis < ActiveRecord::Migration
  def change
    create_table :emojis do |t|
      t.references :user
      t.string "name"
      t.string "transaction"
      t.string "provider"
      t.timestamps
    end
  end
end
