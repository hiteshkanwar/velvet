class CreateAdmires < ActiveRecord::Migration
  def change
    create_table :admires do |t|
      t.references :user
      t.references :post
      t.integer "description"
      t.timestamps
    end
  end
end
