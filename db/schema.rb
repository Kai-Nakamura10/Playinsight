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

ActiveRecord::Schema[8.0].define(version: 2025_10_20_142744) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.bigint "bestselect_id", null: false
    t.text "body"
    t.boolean "is_correct", default: false, null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bestselect_id"], name: "index_answers_on_bestselect_id"
  end

  create_table "bestselects", force: :cascade do |t|
    t.text "question", null: false
    t.text "explanation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "choices", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.text "body", null: false
    t.boolean "is_correct", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_choices_on_question_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "video_id", null: false
    t.bigint "timeline_id"
    t.decimal "video_timestamp_seconds", precision: 8, scale: 2
    t.text "body"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_comments_on_ancestry"
    t.index ["timeline_id"], name: "index_comments_on_timeline_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
    t.index ["video_id"], name: "index_comments_on_video_id"
  end

  create_table "failure_patterns", force: :cascade do |t|
    t.bigint "tactic_id", null: false
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tactic_id"], name: "index_failure_patterns_on_tactic_id"
  end

  create_table "faqs", force: :cascade do |t|
    t.string "body"
    t.string "category"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "faqs_answers", force: :cascade do |t|
    t.bigint "faq_id", null: false
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faq_id"], name: "index_faqs_answers_on_faq_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.text "content", null: false
    t.text "explanation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rules", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.string "slug", null: false
    t.string "youtube_url"
    t.jsonb "aliases", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_rules_on_slug", unique: true
  end

  create_table "success_conditions", force: :cascade do |t|
    t.bigint "tactic_id", null: false
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tactic_id"], name: "index_success_conditions_on_tactic_id"
  end

  create_table "tactics", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "trigger"
    t.jsonb "steps"
    t.string "counters"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timelines", force: :cascade do |t|
    t.bigint "video_id", null: false
    t.string "kind"
    t.decimal "start_seconds", precision: 8, scale: 2, null: false
    t.decimal "end_seconds", precision: 8, scale: 2
    t.string "title"
    t.text "body"
    t.jsonb "payload", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_timelines_on_kind"
    t.index ["video_id"], name: "index_timelines_on_video_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "nickname", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "video_tactics", force: :cascade do |t|
    t.bigint "video_id", null: false
    t.bigint "tactic_id", null: false
    t.integer "display_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tactic_id"], name: "index_video_tactics_on_tactic_id"
    t.index ["video_id", "tactic_id"], name: "index_video_tactics_on_video_id_and_tactic_id", unique: true
    t.index ["video_id"], name: "index_video_tactics_on_video_id"
  end

  create_table "video_tags", force: :cascade do |t|
    t.bigint "video_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_video_tags_on_tag_id"
    t.index ["video_id", "tag_id"], name: "index_video_tags_on_video_id_and_tag_id", unique: true
    t.index ["video_id"], name: "index_video_tags_on_video_id"
  end

  create_table "videos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "description"
    t.integer "duration_seconds"
    t.string "visibility", default: "unlisted", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_videos_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "bestselects"
  add_foreign_key "choices", "questions"
  add_foreign_key "comments", "timelines"
  add_foreign_key "comments", "users"
  add_foreign_key "comments", "videos"
  add_foreign_key "failure_patterns", "tactics"
  add_foreign_key "faqs_answers", "faqs"
  add_foreign_key "success_conditions", "tactics"
  add_foreign_key "timelines", "videos"
  add_foreign_key "video_tactics", "tactics"
  add_foreign_key "video_tactics", "videos"
  add_foreign_key "video_tags", "tags"
  add_foreign_key "video_tags", "videos"
  add_foreign_key "videos", "users"
end
