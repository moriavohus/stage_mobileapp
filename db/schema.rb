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

ActiveRecord::Schema[8.1].define(version: 2026_09_27_221241) do
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

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.string "tone", default: "lavender", null: false
    t.string "domain", default: "strength", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_categories_on_position"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "circle_posts", force: :cascade do |t|
    t.integer "circle_id", null: false
    t.string "author_nick", null: false
    t.text "body", null: false
    t.integer "supports_count", default: 0, null: false
    t.boolean "published", default: true, null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["circle_id", "published_at"], name: "index_circle_posts_on_circle_id_and_published_at"
    t.index ["circle_id"], name: "index_circle_posts_on_circle_id"
  end

  create_table "circles", force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.integer "members_count", default: 0, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_circles_on_category_id"
    t.index ["slug"], name: "index_circles_on_slug", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "title", null: false
    t.string "slug", null: false
    t.string "kind", default: "article", null: false
    t.text "summary"
    t.text "body"
    t.integer "duration_minutes"
    t.string "cover_url"
    t.string "video_url"
    t.boolean "published", default: false, null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_posts_on_category_id"
    t.index ["kind"], name: "index_posts_on_kind"
    t.index ["published", "published_at"], name: "index_posts_on_published_and_published_at"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "email", null: false
    t.string "source", default: "landing", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_subscribers_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "circle_posts", "circles"
  add_foreign_key "circles", "categories"
  add_foreign_key "posts", "categories"
end
