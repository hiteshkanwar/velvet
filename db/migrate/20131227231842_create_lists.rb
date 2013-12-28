class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.references :user
      t.string :name
      t.string :description
      t.timestamps
    end
  end
end
