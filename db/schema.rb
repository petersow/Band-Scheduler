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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110411210500) do

  create_table "event_person_roles", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "person_id"
    t.integer "role_id"
  end

  create_table "events", :force => true do |t|
    t.integer  "performance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_time"
    t.string   "name"
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people_roles", :id => false, :force => true do |t|
    t.integer "person_id"
    t.integer "role_id"
  end

  create_table "performance_roles", :force => true do |t|
    t.integer  "role_id",                           :null => false
    t.integer  "performance_id",                    :null => false
    t.integer  "quantity",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "optional",       :default => false
  end

  create_table "performances", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weekly"
    t.date     "one_off"
    t.integer  "start_hour"
    t.integer  "start_minute"
    t.string   "name"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
