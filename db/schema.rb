# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_16_205227) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "follows", force: :cascade do |t|
    t.bigint "follow_user_id", null: false
    t.bigint "follower_user_id", null: false
    t.datetime "created_at", null: false
    t.index ["follow_user_id", "follower_user_id"], name: "index_follows_on_follow_user_id_and_follower_user_id", unique: true
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.index ["user_id", "post_id"], name: "index_likes_on_user_id_and_post_id", unique: true
  end

  create_table "message_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "opposite_user_id", null: false
    t.boolean "is_delete", null: false
    t.datetime "created_at", null: false
    t.index ["opposite_user_id"], name: "index_message_users_on_opposite_user_id"
    t.index ["user_id"], name: "index_message_users_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "sender_user_id", null: false
    t.string "message_contents", limit: 240, null: false
    t.text "message_image"
    t.bigint "receiver_user_id", null: false
    t.boolean "is_delete", null: false
    t.datetime "created_at", null: false
    t.index ["receiver_user_id"], name: "index_messages_on_receiver_user_id"
    t.index ["sender_user_id"], name: "index_messages_on_sender_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "post_contents", limit: 240, null: false
    t.text "post_image"
    t.boolean "is_delete", null: false
    t.datetime "created_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 45, null: false
    t.string "user_id", limit: 45, null: false
    t.string "self_introduction", limit: 120, default: ""
    t.string "email", limit: 256, null: false
    t.integer "phone_number", default: 0
    t.date "birthday", null: false
    t.text "image", default: ""
    t.boolean "can_like_notification", default: true, null: false
    t.boolean "can_comment_notification", default: true, null: false
    t.boolean "can_message_notification", default: true, null: false
    t.boolean "can_calender_notification", default: true, null: false
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.json "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "follows", "users", column: "follow_user_id"
  add_foreign_key "follows", "users", column: "follower_user_id"
  add_foreign_key "likes", "posts"
  add_foreign_key "likes", "users"
  add_foreign_key "message_users", "users"
  add_foreign_key "message_users", "users", column: "opposite_user_id"
  add_foreign_key "messages", "users", column: "receiver_user_id"
  add_foreign_key "messages", "users", column: "sender_user_id"
  add_foreign_key "posts", "users"
end
