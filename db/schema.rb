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

ActiveRecord::Schema.define(version: 20151013083057) do

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

  create_table "channel_classes", force: :cascade do |t|
    t.string   "title"
    t.string   "intro"
    t.string   "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "channels", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "intro"
    t.string   "picture"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "content"
    t.integer  "channel_class_id"
  end

  add_index "channels", ["channel_class_id"], name: "index_channels_on_channel_class_id"
  add_index "channels", ["user_id"], name: "index_channels_on_user_id"

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

  create_table "good_classes", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "good_comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "good_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "good_comments", ["good_id"], name: "index_good_comments_on_good_id"
  add_index "good_comments", ["user_id"], name: "index_good_comments_on_user_id"

  create_table "good_likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "good_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "good_likes", ["good_id"], name: "index_good_likes_on_good_id"
  add_index "good_likes", ["user_id"], name: "index_good_likes_on_user_id"

  create_table "good_pics", force: :cascade do |t|
    t.string   "file"
    t.integer  "good_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "good_pics", ["good_id"], name: "index_good_pics_on_good_id"

  create_table "good_reads", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "good_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "good_reads", ["good_id"], name: "index_good_reads_on_good_id"
  add_index "good_reads", ["user_id"], name: "index_good_reads_on_user_id"

  create_table "goods", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.float    "price"
    t.float    "original_price"
    t.float    "freight"
    t.integer  "user_id"
    t.integer  "good_class_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "goods", ["good_class_id"], name: "index_goods_on_good_class_id"
  add_index "goods", ["user_id"], name: "index_goods_on_user_id"

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

  create_table "topic_comment_likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_comment_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "topic_comment_likes", ["topic_comment_id"], name: "index_topic_comment_likes_on_topic_comment_id"
  add_index "topic_comment_likes", ["user_id"], name: "index_topic_comment_likes_on_user_id"

  create_table "topic_comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "topic_comments", ["topic_id"], name: "index_topic_comments_on_topic_id"
  add_index "topic_comments", ["user_id"], name: "index_topic_comments_on_user_id"

  create_table "topic_likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "topic_likes", ["topic_id"], name: "index_topic_likes_on_topic_id"
  add_index "topic_likes", ["user_id"], name: "index_topic_likes_on_user_id"

  create_table "topic_pics", force: :cascade do |t|
    t.string   "file"
    t.integer  "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "topic_pics", ["topic_id"], name: "index_topic_pics_on_topic_id"

  create_table "topic_reads", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "topic_reads", ["topic_id"], name: "index_topic_reads_on_topic_id"
  add_index "topic_reads", ["user_id"], name: "index_topic_reads_on_user_id"

  create_table "topics", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "channel_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "topic_type"
  end

  add_index "topics", ["category_id"], name: "index_topics_on_category_id"
  add_index "topics", ["channel_id"], name: "index_topics_on_channel_id"
  add_index "topics", ["user_id"], name: "index_topics_on_user_id"

  create_table "user_comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_user_id"
    t.text     "content"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "user_comments", ["user_id"], name: "index_user_comments_on_user_id"

# Could not dump table "users" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

end
