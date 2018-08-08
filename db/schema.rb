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

ActiveRecord::Schema.define(version: 2018_08_08_034414) do

  create_table "uci_racers", force: :cascade do |t|
    t.string "uci_generated_racer_id"
    t.string "season_id"
    t.integer "uci_id"
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

end
