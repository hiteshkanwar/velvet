class CreateReposts < ActiveRecord::Migration
  def change
    create_table :reposts do |t|
 	  t.references :user
      t.references :post
      t.timestamps
    end
  end
end
