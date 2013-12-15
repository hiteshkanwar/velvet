# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.


ActiveRecord::Schema.define(:version => 20131213074056) do


  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "person"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "admires", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "emojis", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "transaction_id"
    t.string   "provider"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "followings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "follower_id"
    t.boolean  "blocked"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "hash_tags", :force => true do |t|
    t.integer  "post_id"
    t.string   "name"
    t.integer  "count",      :default => 1
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "messages", :force => true do |t|
    t.text     "message_text"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "ancestry"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "filepicker_url"
  end

  create_table "reposts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "username"
    t.string   "hashed_password"
    t.string   "gender"
    t.string   "country"
    t.string   "dob"
    t.text     "about"
    t.string   "filepicker_url",        :default => "main/avatarExample.png"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.string   "forgot_password_token"
  end

end
