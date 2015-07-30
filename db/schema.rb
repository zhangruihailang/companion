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

ActiveRecord::Schema.define(version: 20150730024836) do

  create_table "attachments", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "attachments", ["project_id"], name: "index_attachments_on_project_id"

# Could not dump table "microposts" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.float    "yield_yearly"
    t.integer  "investment_cycle"
    t.string   "risk_rank"
    t.decimal  "borrowing_total"
    t.integer  "min_investment_amount"
    t.date     "latest_payment_date"
    t.date     "latest_expire_date"
    t.string   "repay_type"
    t.text     "introduction"
    t.text     "assets_explain"
    t.text     "risk_control_measures"
    t.text     "guarantee_status"
    t.text     "money_flow"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

# Could not dump table "users" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

end
