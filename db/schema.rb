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

ActiveRecord::Schema.define(version: 20150915124540) do

  create_table "activities", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "starttime"
    t.datetime "endtime"
    t.string   "place"
    t.string   "number_of_people"
    t.string   "pay_type"
    t.integer  "average_cost"
    t.integer  "user_id"
    t.string   "tags"
    t.integer  "apply_up_limit"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "activities", ["user_id"], name: "index_activities_on_user_id"

  create_table "activity_applies", force: :cascade do |t|
    t.integer  "apply_user_id"
    t.integer  "activity_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "activity_applies", ["activity_id"], name: "index_activity_applies_on_activity_id"

  create_table "activity_comments", force: :cascade do |t|
    t.integer  "post_user_id"
    t.integer  "activity_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "content"
  end

  add_index "activity_comments", ["activity_id"], name: "index_activity_comments_on_activity_id"

  create_table "activity_pics", force: :cascade do |t|
    t.string   "file"
    t.integer  "activity_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "activity_pics", ["activity_id"], name: "index_activity_pics_on_activity_id"

  create_table "attachments", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "attachments", ["project_id"], name: "index_attachments_on_project_id"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "likes", force: :cascade do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "micropost_id"
  end

  add_index "likes", ["micropost_id"], name: "index_likes_on_micropost_id"

  create_table "message_pics", force: :cascade do |t|
    t.string   "file"
    t.integer  "micropost_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "message_pics", ["micropost_id"], name: "index_message_pics_on_micropost_id"

# Could not dump table "microposts" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "income"
    t.string   "has_payed"
  end

  add_index "orders", ["project_id"], name: "index_orders_on_project_id"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "post_comments", force: :cascade do |t|
    t.integer  "post_user_id"
    t.integer  "micropost_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "content"
  end

  add_index "post_comments", ["micropost_id"], name: "index_post_comments_on_micropost_id"

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "picture"
    t.text     "abstract"
  end

  add_index "posts", ["category_id"], name: "index_posts_on_category_id"

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

  create_table "smscodes", force: :cascade do |t|
    t.string   "mobile"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

# Could not dump table "users" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

end
