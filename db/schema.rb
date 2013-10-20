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

ActiveRecord::Schema.define(:version => 18) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "role"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "kind"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "drupal_uid"
  end

  create_table "nodes", :force => true do |t|
    t.string   "title"
    t.integer  "author_id"
    t.string   "taxo_type"
    t.string   "taxo_funnel"
    t.string   "taxo_theme"
    t.string   "taxo_source"
    t.date     "pub_date"
    t.string   "path"
    t.integer  "nid"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "author_name"
  end

  create_table "refers", :force => true do |t|
    t.string   "source_medium"
    t.integer  "visits"
    t.integer  "newvisits"
    t.integer  "bounces"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "node_id"
    t.integer  "period"
    t.float    "bounce_rate"
    t.integer  "pageviews"
  end

  create_table "stats", :force => true do |t|
    t.integer  "node_id"
    t.integer  "period"
    t.integer  "pageviews"
    t.float    "bounce_rate"
    t.integer  "visits"
    t.float    "percent_new_visits"
    t.string   "kind"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "new_visits"
  end

end
