class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references :list
      t.references :user
      t.timestamps
    end
  end
end
