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

ActiveRecord::Schema.define(:version => 20131027200003) do

  create_table "communication_preferences", :force => true do |t|
    t.integer  "user_id"
    t.integer  "mark_off",   :default => 1
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "new_debt",   :default => 1
  end

  create_table "expenses", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.integer  "creditor_id"
    t.integer  "debtor_id"
    t.integer  "group_id"
    t.decimal  "amount",      :precision => 10, :scale => 2
    t.boolean  "active",                                     :default => true
    t.string   "action"
  end

  create_table "expenses_notifications", :id => false, :force => true do |t|
    t.integer "expense_id"
    t.integer "notification_id"
  end

  create_table "expenses_payments", :id => false, :force => true do |t|
    t.integer "expense_id"
    t.integer "payment_id"
  end

  create_table "expenses_tags", :id => false, :force => true do |t|
    t.integer "expense_id"
    t.integer "tag_id"
  end

  create_table "groups", :force => true do |t|
    t.string   "gid"
    t.string   "title"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "owner_id"
  end

  add_index "groups", ["gid"], :name => "index_groups_on_gid", :unique => true

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "invitations", :force => true do |t|
    t.string   "token"
    t.integer  "sender_id"
    t.integer  "group_id"
    t.string   "recipient_email"
    t.boolean  "used",            :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "notifications", :force => true do |t|
    t.string   "notif_type"
    t.boolean  "read",         :default => false
    t.integer  "expense_id"
    t.integer  "user_from_id"
    t.integer  "user_to_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "expense_id"
    t.integer  "creditor_id"
    t.integer  "debtor_id"
    t.string   "title"
    t.decimal  "amount"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "reset_tokens", :force => true do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "expires_at"
    t.boolean  "used",       :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "site_notices", :force => true do |t|
    t.string   "title"
    t.datetime "expires_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "auth_token"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "full_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
