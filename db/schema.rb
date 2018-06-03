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

ActiveRecord::Schema.define(version: 2018_06_03_180748) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "book_editions", force: :cascade do |t|
    t.integer "external_contract_id", null: false
    t.text "title", null: false
    t.text "isbn10", null: false
    t.text "isbn13", null: false
    t.integer "edition"
    t.integer "binding"
    t.text "author"
    t.text "description"
    t.date "publish_date"
    t.integer "price"
    t.integer "width"
    t.integer "height"
    t.integer "depth"
    t.boolean "removed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author"], name: "index_book_editions_on_author"
    t.index ["description"], name: "index_book_editions_on_description"
    t.index ["external_contract_id"], name: "index_book_editions_on_external_contract_id", unique: true
    t.index ["isbn10"], name: "index_book_editions_on_isbn10"
    t.index ["isbn13"], name: "index_book_editions_on_isbn13"
    t.index ["title"], name: "index_book_editions_on_title"
  end

  create_table "users", force: :cascade do |t|
    t.text "username", null: false
    t.text "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
