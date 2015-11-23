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

ActiveRecord::Schema.define(version: 20151123120259) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "check_ins", force: true do |t|
    t.integer  "employee_id"
    t.datetime "check_in_time"
    t.datetime "check_out_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_holidays", force: true do |t|
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_holidays", force: true do |t|
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "holiday_request_id"
  end

  create_table "employees", force: true do |t|
    t.string   "email",                            default: "",    null: false
    t.string   "encrypted_password",               default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "post_code"
    t.boolean  "is_line_manager",                  default: false
    t.string   "job_title",                        default: ""
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "active",                           default: true
    t.float    "contracted_hours"
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_relation"
    t.string   "emergency_contact_phone_number"
    t.string   "emergency_contact_phone_number_2"
    t.integer  "line_manager_id"
    t.date     "date_of_birth"
  end

  add_index "employees", ["email"], name: "index_employees_on_email", unique: true, using: :btree
  add_index "employees", ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true, using: :btree

  create_table "holiday_requests", force: true do |t|
    t.integer  "employee_id"
    t.boolean  "authorised",       default: false
    t.integer  "authorised_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_from"
    t.date     "date_to"
  end

  create_table "sick_days", force: true do |t|
    t.date     "date"
    t.integer  "employee_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
