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

ActiveRecord::Schema.define(version: 20170517045647) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "wikipedia_dates", force: :cascade do |t|
    t.string   "permalink"
    t.string   "page_url"
    t.date     "occurred_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wikipedia_dates", ["occurred_on"], name: "index_wikipedia_dates_on_occurred_on", using: :btree
  add_index "wikipedia_dates", ["permalink"], name: "index_wikipedia_dates_on_permalink", using: :btree

  create_table "wikipedia_events", force: :cascade do |t|
    t.integer  "wikipedia_date_id"
    t.string   "permalink"
    t.string   "page_url"
    t.string   "title"
    t.text     "summary"
    t.string   "image_url"
    t.datetime "last_edited_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wikipedia_events", ["permalink"], name: "index_wikipedia_events_on_permalink", using: :btree
  add_index "wikipedia_events", ["wikipedia_date_id"], name: "index_wikipedia_events_on_wikipedia_date_id", using: :btree

end
