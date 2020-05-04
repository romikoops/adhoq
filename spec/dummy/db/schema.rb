# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_19_221608) do

  create_table "adhoq_executions", force: :cascade do |t|
    t.integer "query_id", null: false
    t.text "raw_sql", null: false
    t.string "report_format", null: false
    t.string "status", default: "requested", null: false
    t.text "log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adhoq_hidden_tables", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adhoq_queries", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.text "query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adhoq_reports", force: :cascade do |t|
    t.integer "execution_id", null: false
    t.string "identifier", null: false
    t.time "generated_at", null: false
    t.string "storage", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["execution_id"], name: "index_adhoq_reports_on_execution_id"
  end

  create_table "no_id_tables", id: false, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "secret_tables", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
