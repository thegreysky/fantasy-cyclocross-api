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

ActiveRecord::Schema.define(version: 2018_08_21_115859) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "team_racers", force: :cascade do |t|
    t.integer "uci_racer_id"
    t.integer "team_id"
    t.boolean "active"
    t.integer "season_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "owner"
    t.integer "season_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uci_racers", force: :cascade do |t|
    t.string "uci_generated_racer_id"
    t.string "season_id"
    t.string "uci_id"
    t.string "name"
    t.integer "previous_year_points"
    t.decimal "cost", precision: 5, scale: 2
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country"
    t.string "country_short"
    t.index ["uci_generated_racer_id"], name: "index_uci_racers_on_uci_generated_racer_id", unique: true
  end

  create_table "uci_results", force: :cascade do |t|
    t.integer "racer_id"
    t.integer "race_id"
    t.string "competition_name"
    t.integer "competition_id"
    t.string "category"
    t.integer "place"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["racer_id", "race_id"], name: "index_uci_results_on_racer_id_and_race_id", unique: true
  end

end
