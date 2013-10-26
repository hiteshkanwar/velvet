class CreateHashTags < ActiveRecord::Migration
  def change
    create_table :hash_tags do |t|
      t.references :post
      t.string  "name"
      t.integer "count", default: 1
      t.timestamps
    end
  end
end
