class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user
      t.string "person"
      t.string "description"
      t.timestamps
    end
  end
end
