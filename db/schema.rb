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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150128093306) do

  create_table "accounts", force: true do |t|
    t.string   "email"
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password"
    t.string   "picture_url"
    t.string   "thumbnail_url"
    t.string   "airbnb_id"
    t.integer  "num_claimed",   default: 0
  end

  create_table "ips", force: true do |t|
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "region"
  end

  create_table "listings", force: true do |t|
    t.string   "airbnb_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "airbnb_user_id"
    t.string   "city"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "country"
    t.string   "zipcode"
    t.string   "address"
    t.string   "state"
    t.string   "first_name"
    t.string   "picture_url"
    t.string   "thumbnail_url"
    t.integer  "account_id"
    t.boolean  "intro_sent",     default: false
  end

  create_table "locations", force: true do |t|
    t.string   "state"
    t.string   "city"
    t.integer  "postal"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "searched",   default: false
    t.boolean  "skipped",    default: false
  end

  create_table "messages", force: true do |t|
    t.string   "text"
    t.integer  "listing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "airbnb_thread_id"
  end

end
