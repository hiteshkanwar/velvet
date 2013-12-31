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

ActiveRecord::Schema.define(:version => 20131231105619) do

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

  create_table "advertisers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "tippin_user_name"
    t.string   "company"
    t.string   "phone"
    t.string   "website"
    t.string   "industry"
    t.string   "job_title"
    t.string   "job_function"
    t.string   "plan_id"
    t.string   "campaign_image"
    t.string   "campaign_name"
    t.string   "stripe_customer_token"
    t.string   "uuid"
    t.integer  "user_id"
    t.float    "max_cpm"
    t.float    "total_budget"
    t.float    "ad_served"
    t.boolean  "active",                :default => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.float    "remaining_budget",      :default => 0.0
    t.float    "total_ad_served",       :default => 0.0
    t.boolean  "approved",              :default => false
  end

  create_table "attachments", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "document"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

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

  create_table "lists", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "members", :force => true do |t|
    t.integer  "list_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "messages", :force => true do |t|
    t.text     "message_text"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "ancestry"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "is_trash",     :default => false
    t.boolean  "seen",         :default => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "filepicker_url"
    t.string   "avatar"
    t.string   "avatar_tmp"
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
    t.string   "avatar"
    t.string   "header"
    t.string   "location"
    t.string   "website"
    t.text     "bio"
    t.boolean  "noti_retips",           :default => true
    t.boolean  "noti_admire",           :default => true
    t.boolean  "noti_message",          :default => true
    t.boolean  "noti_follow",           :default => true
    t.boolean  "noti_mention",          :default => true
    t.string   "avatar_tmp"
    t.string   "header_tmp"
  end

end
