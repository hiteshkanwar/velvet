class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "name"
      t.string "email"
      t.string "username"
      t.string "hashed_password"
      t.string "gender"
      t.string "country"
      t.string "dob"
      t.text   "about"
      t.string "filepicker_url", default: "main/avatarExample.png"
      t.timestamps
    end
  end
end
