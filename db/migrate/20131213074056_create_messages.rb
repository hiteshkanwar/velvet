class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :message_text
      t.integer :sender_id
      t.integer :receiver_id
      t.string :ancestry

      t.timestamps
    end
  end
end
