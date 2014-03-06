class CreateSubscribeAndInvitations < ActiveRecord::Migration
  def change
    create_table :subscribe_and_invitations do |t|
      t.boolean :subscribe
      t.references :list
      t.references :user

      t.timestamps
    end
    add_index :subscribe_and_invitations, :list_id
    add_index :subscribe_and_invitations, :user_id
  end
end
