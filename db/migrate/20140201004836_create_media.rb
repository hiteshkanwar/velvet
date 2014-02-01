class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.references :post
      t.string :name
      t.string :url
      t.timestamps
    end
  end
end
