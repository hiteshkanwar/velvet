class CreateHashTags < ActiveRecord::Migration
  def change
    create_table :hash_tags do |t|
      t.references :post
      t.string  "name"
      t.integer "count"
      t.timestamps
    end
  end
end
